module Query.UserQuery exposing (..)

import Adapter.UserApi
import Domain.User exposing (User)
import Http
import Task


findUsers : (Result Http.Error (List User) -> msg) -> String -> Cmd msg
findUsers msg query =
    Task.attempt msg <| Adapter.UserApi.find query
