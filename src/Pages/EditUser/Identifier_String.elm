module Pages.EditUser.Identifier_String exposing (Model, Msg, Params, page)

import Adapter.Helper
import Browser
import Browser.Navigation as Nav
import Domain.User as User exposing (Msg, User)
import Domain.UserRepository as UserRepository
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route exposing (Route)
import Spa.Page as Page exposing (Page)
import Spa.Route
import Spa.Url as Url exposing (Url)


page : Page Params Model Msg
page =
    Page.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Params =
    { identifier : User.Identifier }


type alias Model =
    { user : User
    , message : Maybe Message
    , key : Nav.Key
    }


init : Url Params -> ( Model, Cmd Msg )
init url =
    ( { user = User.create url.params.identifier "" "" ""
      , message = Nothing
      , key = url.key
      }
    , UserRepository.get GetResponse url.params.identifier
    )


type alias Message =
    String



-- UPDATE


type Msg
    = -- On memory case
      UpdateUser User.Msg
      -- Repository case
    | GetRequest User.Identifier
    | GetResponse (Result Http.Error User)
    | SaveRequest User
    | SaveResponse (Result Http.Error User)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- On memory case
        UpdateUser userMsg ->
            let
                ( modifiedUserModel, userCmd ) =
                    User.update userMsg model.user
            in
            ( { model | user = modifiedUserModel }, Cmd.map UpdateUser userCmd )

        -- Repository case
        GetRequest identifier ->
            ( model, UserRepository.get GetResponse identifier )

        GetResponse (Err err) ->
            ( { model | message = Just <| Adapter.Helper.httpErrorMessage err }, Cmd.none )

        GetResponse (Ok user) ->
            ( { model | user = user, message = Nothing }, Cmd.none )

        SaveRequest saveUser ->
            ( model, UserRepository.save SaveResponse saveUser )

        SaveResponse (Err err) ->
            ( { model | message = Just <| Adapter.Helper.httpErrorMessage err }, Cmd.none )

        SaveResponse (Ok savedUser) ->
            ( { model | user = savedUser, message = Nothing }, Spa.Route.navigate model.key Route.Top )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Document Msg
view model =
    let
        submitButton : Html msg
        submitButton =
            button [ style "display" "flex", style "flex" "1" ] [ text "Save" ]
    in
    { title = "EditUser"
    , body =
        [ Html.form [ onSubmit (SaveRequest model.user) ]
            [ Html.map UpdateUser <| User.unitView model.user
            , div [ style "color" "red" ] [ text <| Maybe.withDefault "" model.message ]
            , submitButton
            ]
        ]
    }
