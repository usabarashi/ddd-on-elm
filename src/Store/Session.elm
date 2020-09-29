module Store.Session exposing (..)

import Browser.Navigation
import Domain.Authorize as Authorize exposing (Authorize)


type alias Session =
    { key : Browser.Navigation.Key
    , authorize : Authorize.Token
    }


create : Browser.Navigation.Key -> Authorize -> Session
create key authorize =
    { key = key
    , authorize = authorize.token
    }
