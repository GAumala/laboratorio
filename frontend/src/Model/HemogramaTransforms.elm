module Model.HemogramaTransforms exposing (setHemogramaText, setHemogramaTextFocus)

import Model.FormModel as FormModel
import Model exposing (HemogramaModel)


setHemogramaText : String -> String -> HemogramaModel -> HemogramaModel
setHemogramaText inputId newValue model =
    FormModel.set inputId { value = newValue, hasFocus = True } model


setHemogramaTextFocus : String -> Bool -> HemogramaModel -> HemogramaModel
setHemogramaTextFocus inputId newValue model =
    let
        currentState =
            FormModel.get inputId model
    in
        FormModel.set inputId { currentState | hasFocus = newValue } model
