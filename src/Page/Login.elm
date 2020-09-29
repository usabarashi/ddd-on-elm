module Page.Login exposing (..)

import Adapter.Helper
import Command.Actor as Actor exposing (login)
import Domain.Authenticate as Authenticate exposing (Authenticate)
import Domain.Authorize as Authorize exposing (Authorize)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Store.Session as Sessiont exposing (Session)


type alias Model =
    { authenticate : Authenticate
    , message : Maybe String
    , session : Session
    }


create : Session -> Model
create session =
    { authenticate = Authenticate.init
    , message = Nothing
    , session = session
    }



-- UPDATE


type Msg
    = EnterIdentifier Authenticate.Identifier
    | EnterPassword Authenticate.Password
    | LoginRequest Authenticate
    | LoginResponse (Result Http.Error Authorize)


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
        LoginRequest authenticate ->
            case Authenticate.validate authenticate of
                Err message ->
                    ( { model | message = Just message }
                    , Cmd.none
                    )

                Ok verifiedAuthenticate ->
                    ( { model | authenticate = verifiedAuthenticate }
                    , Actor.login LoginResponse verifiedAuthenticate
                    )

        LoginResponse (Err err) ->
            ( { model | message = Just <| Adapter.Helper.httpErrorMessage err }
            , Cmd.none
            )

        LoginResponse (Ok token) ->
            ( { model | message = Just "Success" }
            , Cmd.none
            )



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
            [ onSubmit (LoginRequest model.authenticate)
            ]
            [ div [] [ identifierInputField ]
            , div [] [ passwordInputField ]
            , submitButton
            ]
        , text <| Maybe.withDefault "" model.message
        ]
