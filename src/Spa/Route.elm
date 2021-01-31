module Spa.Route exposing (..)

import Browser.Navigation as Nav
import Spa.Generated.Route as Route exposing (Route)


navigate : Nav.Key -> Route -> Cmd msg
navigate key route =
    Nav.pushUrl key (Route.toString route)
