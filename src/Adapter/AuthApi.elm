module Adapter.AuthApi exposing (..)

import Adapter.Helper
import Domain.Authenticate as Authenticate exposing (Authenticate)
import Domain.Authorize as Authorize exposing (Authorize)
import Http exposing (..)
import Json.Decode
import Task


authApiUrl : String
authApiUrl =
    "http://127.0.0.1:3000"


login : Authenticate -> Task.Task Http.Error Authorize
login auth =
    let
        requestEncoder : Authenticate -> Http.Body
        requestEncoder decodeAuth =
            Http.multipartBody
                [ stringPart "username" <| Maybe.withDefault "" decodeAuth.maybeIdentifier
                , stringPart "password" <| Maybe.withDefault "" decodeAuth.maybePassword
                ]

        responseDecoder : Json.Decode.Decoder Authorize
        responseDecoder =
            Json.Decode.map2 Authorize.create
                (Json.Decode.field "access_token" Json.Decode.string)
                (Json.Decode.field "token_type" Json.Decode.string)
    in
    Http.task
    --    { method = "POST"
        { method = "GET"
        , headers = []
    --    , url = authApiUrl ++ "/auth/token.json"
        , url = authApiUrl ++ "/dummy_response.json"
        , body = requestEncoder auth
        , resolver = Adapter.Helper.jsonResolver responseDecoder
        , timeout = Nothing
        }
