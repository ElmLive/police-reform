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
    = ZipCodeChanged String


update : Msg -> Model -> Model
update msg model =
    case Debug.log "update" msg of
        ZipCodeChanged newEntry ->
            { model | zipcodeEntry = newEntry }


view : Model -> Html Msg
view model =
    Html.form [ class "pure-form pure-form-aligned" ]
        [ fieldset []
            [ div [ class "pure-control-group" ]
                [ label [ for "zipcode" ] [ text "Zipcode" ]
                , input
                    [ id "zipcode"
                    , type' "text"
                    , classList
                        [ ( "input-invalid", not (Zipcode.isValid model.zipcodeEntry) )
                        ]
                    , onInput ZipCodeChanged
                    ]
                    []
                ]
            ]
        ]


main : Program Never
main =
    Html.App.beginnerProgram
        { model = initialModel
        , update = update
        , view = view
        }
