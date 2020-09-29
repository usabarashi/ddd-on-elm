module Command.Actor exposing (..)

import Adapter.AuthApi
import Domain.Authenticate as Authenticate exposing (Authenticate)
import Domain.Authorize as Authorize exposing (Authorize)
import Http
import Task


login : (Result Http.Error Authorize -> msg) -> Authenticate -> Cmd msg
login msg authenticate =
    Task.attempt msg <| Adapter.AuthApi.login authenticate
