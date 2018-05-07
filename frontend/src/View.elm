module View exposing (view)

import Model exposing (Model, Msg, Section(SetupS))
import View.SetupView as SetupView
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
                SetupView.view model.setupModel

            _ ->
                p [] [ text "not found" ]
