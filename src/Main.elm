module Main exposing (main)

import Adapter.AuthApi
import Adapter.Helper
import Browser
import Browser.Navigation
import Domain.Authorize as Authorize exposing (Authorize)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Page.Login
import Page.Top
import Route exposing (Route)
import Store.Session as Session exposing (Session)
import Url
import Url.Builder



-- MAIN


main : Program (Maybe Authorize.Token) Page Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }



-- MODEL


type Page
    = NotFound Session
    | LoginPage Page.Login.Model
    | TopPage Page.Top.Model


init : Maybe Authorize.Token -> Url.Url -> Browser.Navigation.Key -> ( Page, Cmd Msg )
init maybeToken url key =
    let
        initialSession : Session
        initialSession =
            Session.create key <| Authorize.create (Maybe.withDefault "" maybeToken) ""

        initialPage : Page
        initialPage =
            NotFound initialSession
    in
    switchPage (Route.parse url) initialPage


getSession : Page -> Session
getSession page =
    case page of
        NotFound session ->
            session

        LoginPage model ->
            model.session

        TopPage model ->
            model.session


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | LoginMsg Page.Login.Msg
    | TopMsg Page.Top.Msg


update : Msg -> Page -> ( Page, Cmd Msg )
update msg page =
    let
        session : Session
        session =
            getSession page
    in
    case ( msg, page ) of
        -- Routing case
        ( LinkClicked (Browser.Internal url), _ ) ->
            ( page, Browser.Navigation.pushUrl session.key (Url.toString url) )

        ( LinkClicked (Browser.External href), _ ) ->
            ( page, Browser.Navigation.load href )

        ( UrlChanged url, _ ) ->
            switchPage (Route.parse url) page

        -- Login page case
        ( LoginMsg loginMsg, LoginPage loginModel ) ->
            let
                ( modifiedLoginModel, loginCmd ) =
                    Page.Login.update loginMsg loginModel
            in
            ( LoginPage modifiedLoginModel, Cmd.map LoginMsg loginCmd )

        ( LoginMsg loginMsg, _ ) ->
            ( page, Cmd.none )

        -- Token page case
        ( TopMsg topMsg, TopPage topModel ) ->
            let
                ( newTopModel, topCmd ) =
                    Page.Top.update topMsg topModel
            in
            ( TopPage newTopModel, Cmd.map TopMsg topCmd )

        ( TopMsg topMsg, _ ) ->
            ( page, Cmd.none )


switchPage : Maybe Route -> Page -> ( Page, Cmd Msg )
switchPage maybeRoute page =
    let
        session : Session
        session =
            getSession page
    in
    case maybeRoute of
        Nothing ->
            ( NotFound session
            , Cmd.none
            )

        Just Route.Login ->
            ( LoginPage <| Page.Login.create <| Session.create session.key Authorize.init
            , Cmd.none
            )

        Just Route.Top ->
            let
                ( topModel, topCmd ) =
                    Page.Top.init session
            in
            ( TopPage topModel
            , Cmd.map TopMsg topCmd
            )



-- Subscriptions


subscriptions : Page -> Sub Msg
subscriptions page =
    Sub.none



--  VIEW


view : Page -> Browser.Document Msg
view page =
    { title = "ddd on elm"
    , body =
        let
            logoutButton : msg -> Html msg
            logoutButton msg =
                Html.form
                    [ onSubmit msg ]
                    [ button [ style "padding" "5px", style "backgroundColor" "#DD493A" ] [ text "Logout" ] ]
        in
        [ case page of
            NotFound session ->
                viewNotFound

            LoginPage loginPageModel ->
                Page.Login.view loginPageModel
                    |> Html.map LoginMsg

            TopPage topPageModel ->
                div
                    []
                    [ header
                        [ style "position" "fixed"
                        , style "top" "0"
                        , style "left" "0"
                        , style "width" "100%"
                        , style "height" "40px"
                        , style "display" "flex"
                        , style "flex" "1"
                        , style "flex-direction" "row"
                        , style "alignItems" "center"
                        , style "justify-content" "space-between"
                        , style "borderBottom" "1px solid silver"
                        , style "boxSizing" "border-box"
                        , style "backgroundColor" "#7EB709"
                        ]
                        [ h1
                            [ style "fontSize" "large"
                            , style "fontStyle" "italic"
                            , style "color" "white"
                            , style "margin" "0"
                            ]
                            [ text "ddd on elm" ]
                        ]
                    , Page.Top.view topPageModel
                        |> Html.map TopMsg
                    ]
        ]
    }


viewNotFound : Html msg
viewNotFound =
    text "Not Found"
