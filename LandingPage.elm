port module Main exposing (..)

import Html exposing (Html)
import Html.App
import Json.Encode as Json
import Json.Decode as Decode


type alias Model =
    { localInfo : Maybe ZipcodeInfo }


type alias ZipcodeInfo =
    { policeChief : PersonInfo }


zipcodeInfoDecoder : Decode.Decoder ZipcodeInfo
zipcodeInfoDecoder =
    Decode.object1 ZipcodeInfo
        (Decode.at [ "policeChief" ] personInfoDecoder)


type alias PersonInfo =
    { name : Maybe String }


personInfoDecoder : Decode.Decoder PersonInfo
personInfoDecoder =
    Decode.object1 PersonInfo
        (Decode.at [ "name" ] (Decode.maybe Decode.string))


initialModel : Model
initialModel =
    { localInfo = Nothing }


type Msg
    = GotZipcodeData Json.Value


decodeZipcodeData : Json.Value -> Maybe ZipcodeInfo
decodeZipcodeData json =
    Decode.decodeValue zipcodeInfoDecoder json
        |> Result.toMaybe


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "update" msg of
        GotZipcodeData json ->
            ( { model | localInfo = decodeZipcodeData json }
            , Cmd.none
            )


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
