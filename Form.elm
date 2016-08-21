module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App
import Zipcode


type alias Model =
    { zipcode : Maybe String
    , zipcodeEntry : String
    , departmentType : Maybe DepartmentType
    }


type DepartmentType
    = PoliceDepartment
    | SheriffDepartment


initialModel : Model
initialModel =
    { zipcode = Nothing
    , zipcodeEntry = ""
    , departmentType = Nothing
    }


debuggingModel : Model
debuggingModel =
    { initialModel
        | zipcode = Just "12345"
    }


type Msg
    = ZipcodeChanged String
    | SubmitZipcode
    | ChooseDepartmentType DepartmentType


update : Msg -> Model -> Model
update msg model =
    case Debug.log "update" msg of
        ZipcodeChanged newEntry ->
            { model | zipcodeEntry = newEntry }

        SubmitZipcode ->
            if Zipcode.isValid model.zipcodeEntry then
                { model | zipcode = Just model.zipcodeEntry }
            else
                model

        ChooseDepartmentType departmentType ->
            { model | departmentType = Just departmentType }


zipcodeForm : String -> Html Msg
zipcodeForm zipcodeEntry =
    let
        zipcodeIsInvalid =
            not (Zipcode.isValid zipcodeEntry)
    in
        Html.form
            [ class "pure-form pure-form-aligned"
            , onSubmit SubmitZipcode
            , disabled zipcodeIsInvalid
            ]
            [ fieldset []
                [ div [ class "pure-control-group" ]
                    [ label [ for "zipcode" ] [ text "Zipcode" ]
                    , input
                        [ id "zipcode"
                        , type' "text"
                        , classList
                            [ ( "input-invalid", zipcodeIsInvalid )
                            ]
                        , onInput ZipcodeChanged
                        ]
                        []
                    ]
                , div [ class "pure-controls" ]
                    [ button
                        [ classList
                            [ ( "pure-button", True )
                            , ( "pure-button-primary", True )
                            , ( "pure-button-disabled", zipcodeIsInvalid )
                            ]
                        , type' "submit"
                        , disabled zipcodeIsInvalid
                        ]
                        [ text "Continue" ]
                    ]
                ]
            ]


departmentTypeForm : Html Msg
departmentTypeForm =
    Html.div
        [ class "pure-form"
        ]
        [ p []
            [ text "Are you reporting information about a police department or a sheriff department?" ]
        , p []
            [ button
                [ class "pure-button"
                , onClick (ChooseDepartmentType PoliceDepartment)
                ]
                [ text "Police Department" ]
            ]
        , p []
            [ button
                [ class "pure-button"
                , onClick (ChooseDepartmentType SheriffDepartment)
                ]
                [ text "Sheriff Department" ]
            ]
        ]


view : Model -> Html Msg
view model =
    case model.zipcode of
        Nothing ->
            zipcodeForm model.zipcodeEntry

        Just zipcode ->
            case model.departmentType of
                Nothing ->
                    departmentTypeForm

                Just PoliceDepartment ->
                    text "TODO: police department form"

                Just SheriffDepartment ->
                    text "TODO: sheriff department form"


main : Program Never
main =
    Html.App.beginnerProgram
        { model =
            debuggingModel
            -- TODO: use initialModel
        , update = update
        , view = view
        }
