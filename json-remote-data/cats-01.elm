module Main exposing (..)

import Html exposing (Html, button, text)
import Html.Events exposing (onClick)
import Json.Decode exposing (int, string, float, list, nullable, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import RemoteData exposing (RemoteData(..), WebData)
import RemoteData.Http


{-| Store the data as a `WebData a` type in your model
-}
type alias Model =
    { cat : WebData Cat
    }


{-| Add a message with a `WebData a` parameter
-}
type Msg
    = HandleCatResponse (WebData Cat)
    | GetCat


init : ( Model, Cmd Msg )
init =
    ( { cat = NotAsked }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleCatResponse data ->
            ( { model | cat = data }
            , Cmd.none
            )

        GetCat ->
            ( model
              --, RemoteData.Http.get "/api/cats/1-full.json" HandleCatResponse catPipelineDecoder
              --, RemoteData.Http.get "/api/cats/2-null-color.json" HandleCatResponse catPipelineDecoder
              --, RemoteData.Http.get "/api/cats/3-no-age.json" HandleCatResponse catPipelineDecoder
            --   , RemoteData.Http.get "/api/cats/4-extra-list-field.json" HandleCatResponse catPipelineDecoder
            -- this is the IPFS file address (hash)
              , RemoteData.Http.get "QmRQyUHj9ZwaEFqKzX6sQF8BXa8Xt1hKimRJAma66BxiKd#4-extra-list-field.json" HandleCatResponse catPipelineDecoder
            -- , RemoteData.Http.get "/api/cats/99-does-not-exist.json" HandleCatResponse catPipelineDecoder
            --added QmRQyUHj9ZwaEFqKzX6sQF8BXa8Xt1hKimRJAma66BxiKd 4-extra-list-field.json
            )


view : Model -> Html Msg
view model =
    case model.cat of
        Loading ->
            text "Loading cat data, please stand by..."

        Success cat ->
            text ("Received cat: " ++ toString cat)

        Failure error ->
            text ("Oh noes, cat loading failed with error: " ++ toString error)

        NotAsked ->
            button [ onClick GetCat ] [ text "Get cat data from the server" ]


type alias Cat =
    { name : String
    , color : Maybe String
    , age : Int
    , toys : List String
    }


catPipelineDecoder : Decoder Cat
catPipelineDecoder =
    decode Cat
        |> required "name" string
        |> required "color" (nullable string)
        |> optional "age" int -1
        |> optional "toys" (list string) []


main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
