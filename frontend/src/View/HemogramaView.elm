module View.HemogramaView exposing (view)

import Model
    exposing
        ( HemogramaModel
        , Msg
            ( NoOp
            , TextChange
            , TextFocusChange
            )
        , TextFieldState
        )
import Model.FormModel as FormModel
import Html exposing (Html, div, h1, span, text, table, tr, td)
import Html.Attributes exposing (class, style)
import View.MDL as MDL


type alias FormRowColumns msg =
    { nameLabel : Html msg, inputField : Html msg, unitLabel : Html msg }


formRow : FormRowColumns msg -> Html msg
formRow columns =
    tr [ class "form-row" ]
        [ td [ class "name-label-col" ] [ columns.nameLabel ]
        , td [ class "input-field-col" ] [ columns.inputField ]
        , td [ class "unit-label-col" ] [ columns.unitLabel ]
        ]


numericInputConfig : String -> TextFieldState -> MDL.TextFieldConfig Msg
numericInputConfig id state =
    { fieldLabel = "0"
    , inputId = id
    , isFocused = state.hasFocus
    , value = state.value
    , onFocusChange = TextFocusChange id
    , onInput = TextChange id
    , extraInputAttributes = []
    , labelClass = "numeric-label form-text"
    , inputClass = "numeric-input form-text"
    }


eritrocitosRow : HemogramaModel -> Html Msg
eritrocitosRow model =
    let
        textFieldId =
            "hemograma-eritrocitos-input"

        state =
            FormModel.get textFieldId model
    in
        formRow
            { nameLabel = span [ class "form-text" ] [ text "eritrocitos" ]
            , inputField =
                MDL.textField <| numericInputConfig textFieldId state
            , unitLabel = span [ class "form-text" ] [ text "x 10 6/UL" ]
            }


hematocritoRow : HemogramaModel -> Html Msg
hematocritoRow model =
    let
        textFieldId =
            "hemograma-hematocrito-input"

        state =
            FormModel.get textFieldId model
    in
        formRow
            { nameLabel = span [ class "form-text" ] [ text "hematocrito" ]
            , inputField =
                MDL.textField <| numericInputConfig textFieldId state
            , unitLabel = span [ class "form-text" ] [ text "%" ]
            }


view : HemogramaModel -> Html Msg
view model =
    div []
        [ h1 [] [ text "Hemograma" ]
        , table [ class "center" ]
            [ eritrocitosRow model
            , hematocritoRow model
            ]
        ]
