module Page.Top exposing (Model, Msg(..), init, update, view)

import Domain.User as User exposing (User)
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
    let
        title : Html Msg
        title =
            tr []
                [ th [] [ text "No" ]
                , th [] [ text "Name" ]
                ]

        userView : User -> Html Msg
        userView user =
            tr [ style "border" "solid thin" ]
                [ td [] [ text user.number ]
                , td [] [ text user.name ]
                ]
        
        dummyResponse : List User
        dummyResponse = 
            [   User.init "0000" "0000"
            ,   User.init "0001" "0001"
            ,   User.init "0002" "0002"
            ]
    in
    div
        [ style "margin" "50px 0" ]
        [ div [] [ table [ style "border" "solid thin", style "border-collapse" "collapse" ] <| title :: List.map userView dummyResponse ]
        ]
