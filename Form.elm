module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App
import Zipcode


type alias Model =
    { zipcode : Maybe String
    , zipcodeEntry : String
    }


initialModel : Model
initialModel =
    { zipcode = Nothing
    , zipcodeEntry = ""
    }


type Msg
    = ZipcodeChanged String
    | SubmitZipcode


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


view : Model -> Html Msg
view model =
    case model.zipcode of
        Nothing ->
            zipcodeForm model.zipcodeEntry

        Just zipcode ->
            text "TODO: show police department form"


main : Program Never
main =
    Html.App.beginnerProgram
        { model = initialModel
        , update = update
        , view = view
        }
