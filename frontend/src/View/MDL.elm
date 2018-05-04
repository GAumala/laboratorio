module View.MDL exposing (checkbox, textField)

import Html exposing (Attribute, Html, div, input, label, span, text)
import Html.Attributes exposing (class, for, id, name, type_)


type alias TextFieldConfig =
    { fieldLabel : String
    , inputId : String
    }


type alias CheckboxConfig =
    { fieldLabel : String
    , inputId : String
    }


textField : TextFieldConfig -> List (Attribute msg) -> Html msg
textField config attributes =
    let
        mergedAttributes =
            attributes
                ++ [ type_ "text"
                   , class "mdl-textfield__input"
                   , id config.inputId
                   ]
    in
        div [ class "mdl-textfield mdl-js-textfield mdl-textfield--floating-label" ]
            [ input
                mergedAttributes
                []
            , label
                [ class "mdl-textfield__label"
                , for config.inputId
                ]
                [ text config.fieldLabel ]
            ]


checkbox : TextFieldConfig -> List (Attribute msg) -> Html msg
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
