module View.MDL exposing (TextFieldConfig, checkbox, deletableChip, mainButton, textField)

import Html exposing (Attribute, Html, button, div, i, input, label, span, text)
import Html.Attributes
    exposing
        ( autocomplete
        , class
        , for
        , id
        , name
        , style
        , type_
        , value
        )
import Html.Events exposing (onBlur, onClick, onFocus, onInput)


type alias TextFieldConfig msg =
    { fieldLabel : String
    , inputId : String
    , value : String
    , isFocused : Bool
    , onInput : String -> msg
    , onFocusChange : Bool -> msg
    , extraInputAttributes : List (Attribute msg)
    , labelClass : String
    , inputClass : String
    }


type alias CheckboxConfig =
    { fieldLabel : String
    , inputId : String
    }


type alias DeletableChipConfig msg =
    { text : String
    , onClick : msg
    }


type alias MainButtonConfig msg =
    { text : String
    , onClick : msg
    }


textField : TextFieldConfig msg -> Html msg
textField config =
    let
        attributes =
            [ type_ "text"
            , class inputClass
            , id config.inputId
            , autocomplete False
            , value config.value
            , onInput config.onInput
            , onFocus <| config.onFocusChange True
            , onBlur <| config.onFocusChange False
            ]
                ++ config.extraInputAttributes

        isDirtyClass =
            if config.value /= "" then
                " is-dirty"
            else
                ""

        isFocusedClass =
            if config.isFocused then
                " is-focused"
            else
                ""

        containerClass =
            "mdl-textfield mdl-js-textfield" ++ isDirtyClass ++ isFocusedClass

        labelClass =
            "mdl-textfield__label " ++ config.labelClass

        inputClass =
            "mdl-textfield__input " ++ config.inputClass
    in
        div [ class containerClass ]
            [ input
                attributes
                []
            , label
                [ class labelClass
                , for config.inputId
                ]
                [ text config.fieldLabel ]
            ]


checkbox : CheckboxConfig -> List (Attribute msg) -> Html msg
checkbox config attributes =
    let
        mergedAttributes =
            attributes
                ++ [ type_ "checkbox"
                   , class "mdl-checkbox__input"
                   , id config.inputId
                   ]
    in
        label
            [ class "mdl-checkbox mdl-js-checkbox mdl-js-ripple-effect"
            , for config.inputId
            ]
            [ input
                mergedAttributes
                []
            , span
                [ class "mdl-checkbox__label" ]
                [ text config.fieldLabel ]
            ]


deletableChip : DeletableChipConfig msg -> Html msg
deletableChip config =
    span [ class "mdl-chip mdl-chip--deletable" ]
        [ span [ class "mdl-chip__text" ] [ text config.text ]
        , button
            [ type_ "button"
            , class "mdl-chip__action"
            , onClick config.onClick
            ]
            [ i [ class "material-icons" ] [ text "cancel" ] ]
        ]


mainButton : MainButtonConfig msg -> Html msg
mainButton config =
    button
        [ class "mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect mdl-button--colored"
        , onClick config.onClick
        ]
        [ text config.text ]
