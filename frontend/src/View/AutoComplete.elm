module View.AutoComplete exposing (AutoCompleteKey(Up, Down, Select, Other), onAutoCompleteKeyDown)

import Html exposing (Attribute)
import View.KeyboardEvents exposing (onKeyDown)


type AutoCompleteKey
    = Up
    | Down
    | Select
    | Other Int


onAutoCompleteKeyDown : (AutoCompleteKey -> msg) -> Attribute msg
onAutoCompleteKeyDown fn =
    onKeyDown
        (\keyCode ->
            case keyCode of
                38 ->
                    fn Up

                40 ->
                    fn Down

                13 ->
                    fn Select

                key ->
                    fn <| Other key
        )
