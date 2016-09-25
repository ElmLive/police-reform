port module Main exposing (..)

import Date exposing (Date)
import Dict exposing (Dict)
import Html exposing (Html)
import Html.App
import Json.Encode as Json
import Json.Decode as Decode
import String


type alias Model =
    { localInfo : Maybe ZipcodeInfo }


type alias ZipcodeInfo =
    { policeChief : PersonInfo
    , mayor : PersonInfo
    }


zipcodeInfoDecoder : Decode.Decoder ZipcodeInfo
zipcodeInfoDecoder =
    Decode.object2 ZipcodeInfo
        (Decode.at [ "policeChief" ] personInfoDecoder)
        (Decode.at [ "mayor" ] personInfoDecoder)


type alias PersonInfo =
    { name : Maybe String
    , terms : List TermInfo
    }


personInfoDecoder : Decode.Decoder PersonInfo
personInfoDecoder =
    Decode.object2 PersonInfo
        (Decode.at [ "name" ] (Decode.maybe Decode.string))
        (Decode.oneOf
            [ Decode.at [ "terms" ] (Decode.dict termInfoDecoder)
            , Decode.succeed (Dict.empty)
            ]
            |> Decode.map Dict.toList
            |> Decode.map (List.map snd)
        )


type alias TermInfo =
    { start : Month
    , end : Maybe Month
    }


termInfoDecoder : Decode.Decoder TermInfo
termInfoDecoder =
    Decode.object2 TermInfo
        (Decode.at [ "start" ] decodeMonth)
        (Decode.oneOf
            [ Decode.at [ "end" ] (Decode.maybe decodeMonth)
            , Decode.succeed Nothing
            ]
        )


type alias Month =
    { year : Int
    , month : Int
    }


decodeMonth : Decode.Decoder Month
decodeMonth =
    Decode.customDecoder Decode.string
        (\dateString ->
            case String.split "-" dateString of
                [ yearString, monthString ] ->
                    case ( String.toInt yearString, String.toInt monthString ) of
                        ( Ok year, Ok month ) ->
                            Ok (Month year month)

                        _ ->
                            Err ("Expected a month, but got " ++ dateString)

                _ ->
                    Err ("Expected a month, but got " ++ dateString)
        )


initialModel : Model
initialModel =
    { localInfo = Nothing }


type Msg
    = GotZipcodeData Json.Value


decodeZipcodeData : Json.Value -> Maybe ZipcodeInfo
decodeZipcodeData json =
    Decode.decodeValue zipcodeInfoDecoder json
        |> Result.formatError (Debug.log "decoding error")
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
