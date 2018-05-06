module View.MDL exposing (checkbox, deletableChip, textField)

import Html exposing (Attribute, Html, button, div, i, input, label, span, text)
import Html.Attributes exposing (autocomplete, class, for, id, name, type_)
import Html.Events exposing (onClick)


type alias TextFieldConfig =
    { fieldLabel : String
    , inputId : String
    }


type alias CheckboxConfig =
    { fieldLabel : String
    , inputId : String
    }


type alias DeletableChipConfig msg =
    { text : String
    , onClick : msg
    }


textField : TextFieldConfig -> List (Attribute msg) -> Html msg
textField config attributes =
    let
        mergedAttributes =
            attributes
                ++ [ type_ "text"
                   , class "mdl-textfield__input"
                   , id config.inputId
                   , autocomplete False
                   ]

        containerClass =
            "mdl-textfield mdl-js-textfield mdl-textfield--floating-label"
    in
        div [ class containerClass ]
            [ input
                mergedAttributes
                []
            , label
                [ class "mdl-textfield__label"
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
