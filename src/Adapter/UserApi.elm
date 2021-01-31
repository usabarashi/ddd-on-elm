module Adapter.UserApi exposing (..)

import Adapter.Helper
import Domain.User as User exposing (User)
import Http exposing (..)
import Json.Decode
import Json.Encode
import Task


apiUrl : String
apiUrl =
    "http://127.0.0.1:8000"


get : User.Identifier -> Task.Task Http.Error User
get queryIdentifier =
    let
        responseDecoder : Json.Decode.Decoder User
        responseDecoder =
            Json.Decode.map4 User.create
                (Json.Decode.field "identifier" Json.Decode.string)
                (Json.Decode.field "password" Json.Decode.string)
                (Json.Decode.field "name" Json.Decode.string)
                (Json.Decode.field "emailAddress" Json.Decode.string)
    in
    Http.task
        { method = "GET"
        , headers = []
        , url = apiUrl ++ "/api/user.json" -- ++ queryIdentifier
        , body = Http.emptyBody
        , resolver = Adapter.Helper.jsonResolver responseDecoder
        , timeout = Nothing
        }


save : User -> Task.Task Http.Error User
save saveUser =
    let
        requestEncoder : User -> Json.Encode.Value
        requestEncoder user =
            Json.Encode.object
                [ ( "identifier", Json.Encode.string <| user.identifier )
                , ( "password", Json.Encode.string <| user.password )
                , ( "name", Json.Encode.string <| user.name )
                , ( "emailAddress", Json.Encode.string <| user.emailAddress )
                ]

        responseDecoder : Json.Decode.Decoder User
        responseDecoder =
            Json.Decode.map4 User.create
                (Json.Decode.field "identifier" Json.Decode.string)
                (Json.Decode.field "password" Json.Decode.string)
                (Json.Decode.field "name" Json.Decode.string)
                (Json.Decode.field "emailAddress" Json.Decode.string)
    in
    Http.task
        { method = "GET" -- "POST"
        , headers = []
        , url = apiUrl ++ "/api/user.json"
        , body = Http.emptyBody -- Http.jsonBody <| requestEncoder saveUser
        , resolver = Adapter.Helper.jsonResolver responseDecoder
        , timeout = Nothing
        }


find : String -> Task.Task Http.Error (List User)
find query =
    let
        responseDecoder : Json.Decode.Decoder (List User)
        responseDecoder =
            let
                complementer : User.Identifier -> User.Name -> User.EMailAddress -> User
                complementer identifier name emailAddress =
                    User.create identifier "" name emailAddress
            in
            Json.Decode.list <|
                Json.Decode.map3
                    complementer
                    (Json.Decode.field "identifier" Json.Decode.string)
                    (Json.Decode.field "name" Json.Decode.string)
                    (Json.Decode.field "emailAddress" Json.Decode.string)
    in
    Http.task
        { method = "GET"
        , headers =
            [ header "Accept" "application/json"
            , header "Content-Type" "application/json"
            ]
        , url = apiUrl ++ "/api/users.json" -- ++ query
        , body = Http.emptyBody
        , resolver = Adapter.Helper.jsonResolver responseDecoder
        , timeout = Nothing
        }
