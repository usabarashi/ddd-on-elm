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
    , confirmPassword : Maybe Password
    , validPassword : Maybe ErrorMessage
    , name : Name
    , emailAddress : EMailAddress
    , validEMailAddres : Maybe ErrorMessage
    }


create : Identifier -> Password -> Name -> EMailAddress -> User
create identifier password name emailAddress =
    { identifier = identifier
    , password = password
    , name = name
    , confirmPassword = Nothing
    , validPassword = Nothing
    , emailAddress = emailAddress
    , validEMailAddres = Nothing
    }


type alias Identifier =
    String


type alias Password =
    String


type alias Name =
    String


type alias EMailAddress =
    String


type alias ErrorMessage =
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
                validPassword : Maybe ErrorMessage
                validPassword =
                    if model.confirmPassword == Nothing then
                        Nothing

                    else if password == Maybe.withDefault "" model.confirmPassword then
                        Nothing

                    else
                        Just "Password mismatch."
            in
            ( { model | password = password, validPassword = validPassword }, Cmd.none )

        EnterConfirmPassword confirmPassword ->
            let
                maybeConfirmPassword : Maybe Password
                maybeConfirmPassword =
                    if confirmPassword == "" then
                        Nothing

                    else
                        Just confirmPassword

                validPassword : Maybe ErrorMessage
                validPassword =
                    if confirmPassword == "" then
                        Nothing

                    else if model.password == confirmPassword then
                        Nothing

                    else
                        Just "Password mismatch."
            in
            ( { model
                | confirmPassword = maybeConfirmPassword
                , validPassword = validPassword
              }
            , Cmd.none
            )

        EnterName name ->
            ( { model | name = name }, Cmd.none )

        EnterEMailAddress emailAddress ->
            let
                validEMailAddress : Maybe ErrorMessage
                validEMailAddress =
                    if Email.isValid emailAddress then
                        Nothing

                    else
                        Just "Invalid email address format."
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
                , value <| Maybe.withDefault "" model.confirmPassword
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
        , div [ style "color" "red" ] [ text <| Maybe.withDefault "" model.validPassword ]
        , div [] [ nameInputField ]
        , div [] [ emailAddressInputField ]
        , div [ style "color" "red" ] [ text <| Maybe.withDefault "" model.validEMailAddres ]
        ]
