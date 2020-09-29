module Page.Top exposing (Model, Msg(..), init, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Store.Session as Session exposing (Session)



-- MODEL


type alias Model =
    { message : String
    , session : Session
    }


init : Session -> ( Model, Cmd Msg )
init session =
    let
        model : Model
        model =
            { message = ""
            , session = session
            }
    in
    ( model
    , Cmd.none
    )



-- UPDATE


type Msg
    = None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div
        []
        [ text model.session.authorize
        ]
