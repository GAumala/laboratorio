module View.KeyboardEvents exposing (onKeyDown)

import Html exposing (Attribute)
import Html.Events exposing (on, keyCode)
import Json.Decode as Json


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)
