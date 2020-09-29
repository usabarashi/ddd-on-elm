module Route exposing (Route(..), parse, parser, replaceUrl, routeToString)

import Browser.Navigation
import Url exposing (Url)
import Url.Parser exposing (..)


type Route
    = Login
    | Top


parse : Url -> Maybe Route
parse url =
    Url.Parser.parse parser url


parser : Url.Parser.Parser (Route -> a) a
parser =
    Url.Parser.oneOf
        [ Url.Parser.map Login top
        , Url.Parser.map Top (Url.Parser.s "top")
        ]


replaceUrl : Browser.Navigation.Key -> Route -> Cmd msg
replaceUrl key route =
    Browser.Navigation.replaceUrl key (routeToString route)


routeToString : Route -> String
routeToString page =
    case page of
        Login ->
            "/"

        Top ->
            "/top"
