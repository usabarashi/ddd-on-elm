module Pages.FindUser.Query_String exposing (Model, Msg, Params, page)

import Adapter.Helper
import Domain.User as User exposing (User)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Query.UserQuery
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
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
    { query : Query }


type alias Model =
    { query : Query
    , users : List User
    , message : Maybe Message
    }


type alias Query =
    String


type alias Message =
    String


init : Url Params -> ( Model, Cmd Msg )
init { params } =
    ( { query = params.query
      , users = []
      , message = Nothing
      }
    , Query.UserQuery.findUsers SearchResponse params.query
    )



-- UPDATE


type Msg
    = EnterQuery Query
      -- Query case
    | SearchRequest Query
    | SearchResponse (Result Http.Error (List User))
      -- Nest message case
    | ViewUser User.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        EnterQuery query ->
            ( { model | query = query }, Cmd.none )

        -- Query case
        SearchRequest query ->
            ( { model | query = query }, Query.UserQuery.findUsers SearchResponse query )

        SearchResponse (Err err) ->
            ( { model | message = Just <| Adapter.Helper.httpErrorMessage err }, Cmd.none )

        SearchResponse (Ok users) ->
            ( { model | users = users, message = Nothing }, Cmd.none )

        -- Nest message case
        ViewUser userMsg ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Document Msg
view model =
    let
        queryInputField : Html Msg
        queryInputField =
            input
                [ type_ "text"
                , placeholder "* Enter query."
                , value model.query
                , onInput EnterQuery
                ]
                []

        submitButton : Html Msg
        submitButton =
            button [ style "display" "flex", style "flex" "1" ] [ text "Search" ]

        title =
            Html.map ViewUser User.listTitle

        userViewList =
            List.map (Html.map ViewUser) (List.map User.listView model.users)
    in
    { title = "FindUser"
    , body =
        [ Html.form
            [ onSubmit (SearchRequest model.query)
            ]
            [ table []
                [ tr
                    [ style "border" "solid thin" ]
                    [ td [] [ queryInputField ]
                    , td [] [ submitButton ]
                    ]
                ]
            ]
        , div [ style "color" "red" ] [ text <| Maybe.withDefault "" model.message ]
        , table [ style "border" "solid thin", style "border-collapse" "collapse" ] <|
            title
                :: userViewList
        ]
    }
