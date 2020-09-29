module Domain.Authenticate exposing (Authenticate, Identifier, Password, init, validate)


type alias Authenticate =
    { maybeIdentifier : Maybe Identifier
    , maybePassword : Maybe Password
    }


init : Authenticate
init =
    { maybeIdentifier = Nothing
    , maybePassword = Nothing
    }


validate : Authenticate -> Result String Authenticate
validate authenticate =
    case ( authenticate.maybeIdentifier, authenticate.maybePassword ) of
        ( Nothing, Nothing ) ->
            Err "ID and password not entered."

        ( Just "", Just "" ) ->
            Err "ID and password not entered."

        ( Nothing, _ ) ->
            Err "ID no entered."

        ( Just "", _ ) ->
            Err "ID no entered."

        ( _, Nothing ) ->
            Err "Password not entered."

        ( _, Just "" ) ->
            Err "Password not entered."

        _ ->
            Ok authenticate


type alias Identifier =
    String


type alias Password =
    String
