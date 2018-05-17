module Model.FormModel exposing (set, get)

import Dict
import Maybe exposing (withDefault)
import Model exposing (TextFieldState)


type alias FormModel c =
    { c | textFields : Dict.Dict String TextFieldState }


set : String -> TextFieldState -> FormModel c -> FormModel c
set id input model =
    { model | textFields = Dict.insert id input model.textFields }


get : String -> FormModel c -> TextFieldState
get id model =
    Dict.get id model.textFields |> withDefault { value = "", hasFocus = False }
