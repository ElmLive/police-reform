port module Main exposing (..)

import Html exposing (Html)
import Html.App
import Json.Encode as Json


type alias Model =
    { localInfo : Maybe String }


initialModel : Model
initialModel =
    { localInfo = Nothing }


type Msg
    = GotZipcodeData Json.Value


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "update" msg of
        GotZipcodeData json ->
            ( model, Cmd.none )


view : Model -> Html msg
view model =
    Html.text <| toString model


port changeZipcode : String -> Cmd msg


port zipcodeData : (Json.Value -> msg) -> Sub msg


main : Program Never
main =
    Html.App.program
        { init = ( initialModel, changeZipcode "94107" )
        , update = update
        , subscriptions = \_ -> zipcodeData GotZipcodeData
        , view = view
        }
