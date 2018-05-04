module View.MDL exposing (textField)

import Html exposing (Attribute, Html, div, input, label, text)
import Html.Attributes exposing (class, for, id, name, type_)


type alias TextFieldConfig =
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
