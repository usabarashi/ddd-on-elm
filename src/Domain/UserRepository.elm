module Domain.UserRepository exposing (..)

import Adapter.UserApi
import Domain.User as User exposing (User)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Task


get : (Result Http.Error User -> msg) -> User.Identifier -> Cmd msg
get msg identifier =
    Task.attempt msg <| Adapter.UserApi.get identifier


save : (Result Http.Error User -> msg) -> User -> Cmd msg
save msg user =
    Task.attempt msg <| Adapter.UserApi.save user
