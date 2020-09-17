module Adapter.AuthApi exposing (..)

import Adapter.Helper
import Http exposing (..)
import Json.Decode
import Json.Encode
import Store.Authenticate as Authenticate exposing (Authenticate)
import Store.Authorize as Authorize exposing (Authorize)
import Task


authApiUrl : String
authApiUrl =
    "http://localhost:8000"


login : Authenticate -> Task.Task Http.Error Authorize
login auth =
    let
        requestEncoder : Authenticate -> Json.Encode.Value
        requestEncoder decodeAuth =
            Json.Encode.object
                [ ( "username", Json.Encode.string <| Maybe.withDefault "" decodeAuth.maybeIdentifier )
                , ( "password", Json.Encode.string <| Maybe.withDefault "" decodeAuth.maybePassword )
                ]

        responseDecoder : Json.Decode.Decoder Authorize
        responseDecoder =
            Json.Decode.map2 Authorize.create
                (Json.Decode.field "access_token" Json.Decode.string)
                (Json.Decode.field "token_type" Json.Decode.string)
    in
    Http.task
        { method = "POST"
        , headers = []
        , url = authApiUrl ++ "/auth/token"
        , body =
            Http.multipartBody
                [ stringPart "username" <| Maybe.withDefault "" auth.maybeIdentifier
                , stringPart "password" <| Maybe.withDefault "" auth.maybePassword
                ]
        , resolver = Adapter.Helper.jsonResolver responseDecoder
        , timeout = Nothing
        }



--, body = Http.jsonBody <| requestEncoder auth