module View exposing (view)

import Model exposing (Model, Msg, Section(SetupS))
import View.SetupView as SetupView
import View.HemogramaView as HemogramaView
import Utils.SelectList as SList
import Html exposing (Html, p, text)


view : Model -> Html Msg
view model =
    let
        currentSection =
            SList.selected model.sections
    in
        case currentSection of
            SetupS ->
                HemogramaView.view model.hemogramaModel

            _ ->
                p [] [ text "not found" ]
