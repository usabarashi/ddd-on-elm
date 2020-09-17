module Main exposing (main)

import Adapter.AuthApi
import Adapter.Helper
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Store.Authenticate as Authenticate exposing (Authenticate)
import Store.Authorize as Authorize exposing (Authorize)
import Task



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { authenticate : Authenticate
    , message : Maybe String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { authenticate = Authenticate.init
      , message = Nothing
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = EnterIdentifier Authenticate.Identifier
    | EnterPassword Authenticate.Password
    | SubmitRequest Authenticate
    | SubmitResponse (Result Http.Error Authorize)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- View case
        EnterIdentifier identifier ->
            let
                authenticate : Authenticate
                authenticate =
                    model.authenticate

                modifiedAuthenticate : Authenticate
                modifiedAuthenticate =
                    { authenticate | maybeIdentifier = Just identifier }
            in
            ( { model | authenticate = modifiedAuthenticate }
            , Cmd.none
            )

        EnterPassword password ->
            let
                authenticate : Authenticate
                authenticate =
                    model.authenticate

                modifiedAuthenticate : Authenticate
                modifiedAuthenticate =
                    { authenticate | maybePassword = Just password }
            in
            ( { model | authenticate = modifiedAuthenticate }
            , Cmd.none
            )

        -- Adapter case
        SubmitRequest authenticate ->
            case Authenticate.validate authenticate of
                Err message ->
                    ( { model | message = Just message }
                    , Cmd.none
                    )

                Ok verifiedAuthenticate ->
                    ( { model | authenticate = verifiedAuthenticate }
                    , Task.attempt SubmitResponse <| Adapter.AuthApi.login verifiedAuthenticate
                    )

        SubmitResponse (Err err) ->
            ( { model | message = Just <| Adapter.Helper.httpErrorMessage err }
            , Cmd.none
            )

        SubmitResponse (Ok token) ->
            ( { model | message = Just "Success" }
            , Cmd.none
            )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    let
        identifierInputField : Html Msg
        identifierInputField =
            input
                [ type_ "text"
                , placeholder "* Enter ID."
                , value <| Maybe.withDefault "" model.authenticate.maybeIdentifier
                , onInput EnterIdentifier
                ]
                []

        passwordInputField : Html Msg
        passwordInputField =
            input
                [ type_ "password"
                , placeholder "* Enter password."
                , value <| Maybe.withDefault "" model.authenticate.maybePassword
                , onInput EnterPassword
                ]
                []

        submitButton : Html Msg
        submitButton =
            button [ style "display" "flex", style "flex" "1" ] [ text "Login" ]
    in
    div
        [ style "display" "flex"
        , style "flex-direction" "column"
        , style "justify-content" "center"
        , style "align-items" "center"
        ]
        [ Html.form
            [ onSubmit (SubmitRequest model.authenticate)
            ]
            [ div [] [ identifierInputField ]
            , div [] [ passwordInputField ]
            , submitButton
            ]
        , text <| Maybe.withDefault "" model.message
        ]
