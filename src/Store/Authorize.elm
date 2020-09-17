module Store.Authorize exposing (..)


type alias Authorize =
    { token : Token
    , tokenType : TokenType
    }


init : Authorize
init =
    { token = ""
    , tokenType = ""
    }


create : Token -> TokenType -> Authorize
create token tokenType =
    { init
        | token = token
        , tokenType = tokenType
    }


type alias Token =
    String


type alias TokenType =
    String
