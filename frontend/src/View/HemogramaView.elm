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
import Model.HemogramaIDs as IDs
import Model.FormModel as FormModel
import Html exposing (Html, div, h1, h3, span, text, table, tr, td)
import Html.Attributes exposing (colspan, class, style)
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


sectionHeaderRow : String -> Html msg
sectionHeaderRow sectionName =
    tr []
        [ td [ class "section-header", colspan 3 ]
            [ span [] [ text sectionName ]
            ]
        ]


submitButtonRow : Html Msg
submitButtonRow =
    tr []
        [ td [ class "submit-button-row", colspan 3 ]
            [ MDL.mainButton { text = "Guardar", onClick = NoOp }
            ]
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


normalFormRow : { inputId : String, state : TextFieldState, name : String, unit : String } -> Html Msg
normalFormRow { inputId, state, name, unit } =
    formRow
        { nameLabel = span [ class "form-text" ] [ text name ]
        , inputField =
            MDL.textField <| numericInputConfig inputId state
        , unitLabel = span [ class "form-text" ] [ text unit ]
        }


eritrocitosRow : HemogramaModel -> Html Msg
eritrocitosRow model =
    let
        inputId =
            IDs.eritrocitos
    in
        normalFormRow
            { inputId = inputId
            , state = FormModel.get inputId model
            , name = "Eritrocitos"
            , unit = "x 10 6/UL"
            }


hematocritoRow : HemogramaModel -> Html Msg
hematocritoRow model =
    let
        inputId =
            IDs.hematocrito
    in
        normalFormRow
            { inputId = inputId
            , state = FormModel.get inputId model
            , name = "Hematócrito"
            , unit = "%"
            }


hemoglobinaRow : HemogramaModel -> Html Msg
hemoglobinaRow model =
    let
        inputId =
            IDs.hemoglobina
    in
        normalFormRow
            { inputId = inputId
            , state = FormModel.get inputId model
            , name = "Hemoglobina"
            , unit = "g/dL"
            }


eritroblastosRow : HemogramaModel -> Html Msg
eritroblastosRow model =
    let
        inputId =
            IDs.eritroblastos
    in
        normalFormRow
            { inputId = inputId
            , state = FormModel.get inputId model
            , name = "Eritroblastos"
            , unit = "%"
            }


reticulocitosRow : HemogramaModel -> Html Msg
reticulocitosRow model =
    let
        inputId =
            IDs.reticulocitos
    in
        normalFormRow
            { inputId = inputId
            , state = FormModel.get inputId model
            , name = "Reticulocitos"
            , unit = "%"
            }


vcmRow : HemogramaModel -> Html Msg
vcmRow model =
    let
        inputId =
            IDs.vcm
    in
        normalFormRow
            { inputId = inputId
            , state = FormModel.get inputId model
            , name = "VCM"
            , unit = "fL"
            }


hcmRow : HemogramaModel -> Html Msg
hcmRow model =
    let
        inputId =
            IDs.hcm
    in
        normalFormRow
            { inputId = inputId
            , state = FormModel.get inputId model
            , name = "HCM"
            , unit = "pg"
            }


mchcRow : HemogramaModel -> Html Msg
mchcRow model =
    let
        inputId =
            IDs.mchc
    in
        normalFormRow
            { inputId = inputId
            , state = FormModel.get inputId model
            , name = "MCHC"
            , unit = "pg"
            }


plaquetasRow : HemogramaModel -> Html Msg
plaquetasRow model =
    let
        inputId =
            IDs.plaquetas
    in
        normalFormRow
            { inputId = inputId
            , state = FormModel.get inputId model
            , name = "Plaquetas"
            , unit = "x 10 3/uL"
            }


mpvRow : HemogramaModel -> Html Msg
mpvRow model =
    let
        inputId =
            IDs.mpv
    in
        normalFormRow
            { inputId = inputId
            , state = FormModel.get inputId model
            , name = "MPV"
            , unit = "fL"
            }


pdwRow : HemogramaModel -> Html Msg
pdwRow model =
    let
        inputId =
            IDs.pdw
    in
        normalFormRow
            { inputId = inputId
            , state = FormModel.get inputId model
            , name = "PDW"
            , unit = "%"
            }


pctRow : HemogramaModel -> Html Msg
pctRow model =
    let
        inputId =
            IDs.pct
    in
        normalFormRow
            { inputId = inputId
            , state = FormModel.get inputId model
            , name = "PCT"
            , unit = "%"
            }


leucocitosRow : HemogramaModel -> Html Msg
leucocitosRow model =
    let
        inputId =
            IDs.leucocitos
    in
        normalFormRow
            { inputId = inputId
            , state = FormModel.get inputId model
            , name = "Contaje leucocitos"
            , unit = "x 10 3/uL"
            }


juvenilesRow : HemogramaModel -> Html Msg
juvenilesRow model =
    let
        inputId =
            IDs.juveniles
    in
        normalFormRow
            { inputId = inputId
            , state = FormModel.get inputId model
            , name = "Juveniles"
            , unit = "%"
            }


cayadosRow : HemogramaModel -> Html Msg
cayadosRow model =
    let
        inputId =
            IDs.cayados
    in
        normalFormRow
            { inputId = inputId
            , state = FormModel.get inputId model
            , name = "Cayados"
            , unit = "%"
            }


segmentadosRow : HemogramaModel -> Html Msg
segmentadosRow model =
    let
        inputId =
            IDs.segmentados
    in
        normalFormRow
            { inputId = inputId
            , state = FormModel.get inputId model
            , name = "Segmentados"
            , unit = "%"
            }


eosinofilosRow : HemogramaModel -> Html Msg
eosinofilosRow model =
    let
        inputId =
            IDs.eosinofilos
    in
        normalFormRow
            { inputId = inputId
            , state = FormModel.get inputId model
            , name = "Eosinófilos"
            , unit = "%"
            }


basofilosRow : HemogramaModel -> Html Msg
basofilosRow model =
    let
        inputId =
            IDs.basofilos
    in
        normalFormRow
            { inputId = inputId
            , state = FormModel.get inputId model
            , name = "Basófilos"
            , unit = "%"
            }


monocitosRow : HemogramaModel -> Html Msg
monocitosRow model =
    let
        inputId =
            IDs.monocitos
    in
        normalFormRow
            { inputId = inputId
            , state = FormModel.get inputId model
            , name = "Monocitos"
            , unit = "%"
            }


linfocitosRow : HemogramaModel -> Html Msg
linfocitosRow model =
    let
        inputId =
            IDs.linfocitos
    in
        normalFormRow
            { inputId = inputId
            , state = FormModel.get inputId model
            , name = "Linfocitos"
            , unit = "%"
            }


view : HemogramaModel -> Html Msg
view model =
    div []
        [ h1 [] [ text "Hemograma" ]
        , table [ class "center" ]
            [ sectionHeaderRow "Eritrograma"
            , eritrocitosRow model
            , hematocritoRow model
            , hemoglobinaRow model
            , eritroblastosRow model
            , reticulocitosRow model
            , vcmRow model
            , hcmRow model
            , mchcRow model
            , plaquetasRow model
            , mpvRow model
            , pdwRow model
            , pctRow model
            , sectionHeaderRow "Leucograma"
            , leucocitosRow model
            , juvenilesRow model
            , cayadosRow model
            , segmentadosRow model
            , eosinofilosRow model
            , basofilosRow model
            , monocitosRow model
            , linfocitosRow model
            , submitButtonRow
            ]
        ]
