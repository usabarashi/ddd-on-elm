module Domain.User exposing (User, init)


type alias User =
    { number : String 
    , name : String
    }

init : Number -> Name -> User
init number name =
    { number = number
    , name = name
    }


type alias Number = String
type alias Name = String