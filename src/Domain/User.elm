module Domain.User exposing (..)

import Email
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Spa.Generated.Route as Route



-- MODEL


type alias User =
    { identifier : Identifier
    , password : Password
    , confirmPassword : Password
    , validPassword : String
    , name : Name
    , emailAddress : EMailAddress
    , validEMailAddres : String
    }


create : Identifier -> Password -> Name -> EMailAddress -> User
create identifier password name emailAddress =
    { identifier = identifier
    , password = password
    , name = name
    , confirmPassword = ""
    , validPassword = ""
    , emailAddress = emailAddress
    , validEMailAddres = ""
    }


type alias Identifier =
    String


type alias Password =
    String


type alias Name =
    String


type alias EMailAddress =
    String



-- UPDATE


type Msg
    = -- On memory case
      EnterIdentifier Identifier
    | EnterPassword Password
    | EnterConfirmPassword Password
    | EnterName Name
    | EnterEMailAddress EMailAddress


update : Msg -> User -> ( User, Cmd Msg )
update msg model =
    case msg of
        -- On memory case
        EnterIdentifier identifier ->
            ( { model | identifier = identifier }, Cmd.none )

        EnterPassword password ->
            let
                validPassword : String
                validPassword =
                    if password == model.confirmPassword then
                        ""

                    else
                        "Password mismatch."
            in
            ( { model | password = password, validPassword = validPassword }, Cmd.none )

        EnterConfirmPassword confirmPassword ->
            let
                validPassword : String
                validPassword =
                    if model.password == confirmPassword then
                        ""

                    else
                        "Password mismatch."
            in
            ( { model | confirmPassword = confirmPassword, validPassword = validPassword }, Cmd.none )

        EnterName name ->
            ( { model | name = name }, Cmd.none )

        EnterEMailAddress emailAddress ->
            let
                validEMailAddress =
                    if Email.isValid emailAddress then
                        ""

                    else
                        "Invalid email address format."
            in
            ( { model | emailAddress = emailAddress, validEMailAddres = validEMailAddress }, Cmd.none )



-- VIEW


listTitle : Html msg
listTitle =
    tr []
        [ th [] [ text "ID" ]
        , th [] [ text "Name" ]
        , th [] [ text "EMail Address" ]
        ]


listView : User -> Html msg
listView model =
    tr [ style "border" "solid thin" ]
        [ td []
            [ a [ class "link", href <| Route.toString Route.EditUser ++ "/" ++ model.identifier ]
                [ text model.identifier ]
            ]
        , td [] [ text model.name ]
        , td [] [ text model.emailAddress ]
        ]


unitView : User -> Html Msg
unitView model =
    let
        identifierInputField : Html Msg
        identifierInputField =
            input
                [ type_ "text"
                , placeholder "* Enter ID."
                , value model.identifier
                , onInput EnterIdentifier
                ]
                []

        passwordInputField : Html Msg
        passwordInputField =
            input
                [ type_ "password"
                , placeholder "* Enter password."
                , value model.password
                , onInput EnterPassword
                ]
                []

        confirmPasswordInputField : Html Msg
        confirmPasswordInputField =
            input
                [ type_ "password"
                , placeholder "* Enter confirm password."
                , value model.confirmPassword
                , onInput EnterConfirmPassword
                ]
                []

        nameInputField : Html Msg
        nameInputField =
            input
                [ type_ "text"
                , placeholder "* Enter name."
                , value model.name
                , onInput EnterName
                ]
                []

        emailAddressInputField : Html Msg
        emailAddressInputField =
            input
                [ type_ "text"
                , placeholder "* Enter email address."
                , value model.emailAddress
                , onInput EnterEMailAddress
                ]
                []
    in
    div []
        [ div [] [ identifierInputField ]
        , div [] [ passwordInputField ]
        , div [] [ confirmPasswordInputField ]
        , div [ style "color" "red" ] [ text model.validPassword ]
        , div [] [ nameInputField ]
        , div [] [ emailAddressInputField ]
        , div [ style "color" "red" ] [ text model.validEMailAddres ]
        ]
