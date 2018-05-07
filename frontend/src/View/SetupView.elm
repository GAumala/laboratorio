module View.SetupView exposing (view)

import UStruct.USet as USet
import Utils.SelectList as SList
import Model
    exposing
        ( SetupModel
        , Doctor
        , Patient
        , CurrentPatient
            ( UnknownPatient
            , KnownPatient
            )
        , CurrentDoctor
            ( UnknownDoctor
            , KnownDoctor
            )
        , Msg
            ( CheckTest
            , ChangeFocusedDoctor
            , ChangeFocusedPatient
            , CommitDoctor
            , CommitPatient
            , UncheckTest
            , ResetDoctor
            , ResetPatient
            , TextChange
            , TextFocusChange
            , NoOp
            )
        , MedicalTest
            ( Bioquimico
            , Coproparasitario
            , Enzimatico
            , Examen
            , Hemograma
            , Hemostatico
            , Orina
            , Parasitologico
            , Serologico
            )
        , TextFieldId
            ( DoctorSetup
            , PatientSetup
            )
        , medicalTestName
        , medicalTestToString
        )
import Html
    exposing
        ( Html
        , a
        , br
        , form
        , input
        , text
        , div
        , h1
        , img
        , label
        , li
        , p
        , ul
        , strong
        , table
        , tr
        , td
        )
import Html.Attributes exposing (class, classList, for, checked, id, name, placeholder, type_, value)
import View.MDL as MDL
import View.AutoComplete as AC
import Html.Events exposing (onCheck, onInput)


autoCompleteClassesByPosition : SList.Position -> String
autoCompleteClassesByPosition position =
    if position == SList.Selected then
        "autocomplete-item key-selected"
    else
        "autocomplete-item"


suggestedDoctorRow : SList.Position -> Doctor -> Html Msg
suggestedDoctorRow position doctor =
    let
        classes =
            autoCompleteClassesByPosition position
    in
        li [ class classes ] [ text doctor.name ]


suggestedPatientRow : SList.Position -> Patient -> Html Msg
suggestedPatientRow position patient =
    let
        classes =
            autoCompleteClassesByPosition position
    in
        li [ class classes ] [ text patient.name ]


onDoctorACKeysPressed : AC.AutoCompleteKey -> Msg
onDoctorACKeysPressed key =
    case key of
        AC.Up ->
            ChangeFocusedDoctor True

        AC.Down ->
            ChangeFocusedDoctor False

        AC.Select ->
            CommitDoctor

        _ ->
            NoOp


onPatientACKeysPressed : AC.AutoCompleteKey -> Msg
onPatientACKeysPressed key =
    case key of
        AC.Up ->
            ChangeFocusedPatient True

        AC.Down ->
            ChangeFocusedPatient False

        AC.Select ->
            CommitPatient

        _ ->
            NoOp


suggestionsListView : SuggestionsConfig a -> Html Msg
suggestionsListView config =
    case config.maybeSuggestions of
        Just suggestedItems ->
            ul [ class "autocomplete-list" ] <|
                SList.toList <|
                    SList.mapBy config.suggestionItemView suggestedItems

        Nothing ->
            div [] []


autoCompleteInput : SuggestionsConfig a -> Html Msg
autoCompleteInput config =
    let
        inputView =
            MDL.textField
                { fieldLabel = config.hint
                , inputId = config.inputId
                , value = config.queryText
                , onInput = config.onQueryTextInput
                , isFocused = config.isFocused
                , onFocusChange = config.onFocusChange
                }
                [ AC.onAutoCompleteKeyDown config.onAutoCompleteKeyDown
                ]

        suggestionsList =
            suggestionsListView config
    in
        div [ class "autocomplete-menu setup-input" ]
            [ inputView
            , suggestionsList
            ]


onMedicalTestCheckEvent : MedicalTest -> (Bool -> Msg)
onMedicalTestCheckEvent medicalTest =
    (\isChecked ->
        if isChecked then
            CheckTest
                medicalTest
        else
            UncheckTest medicalTest
    )


medicalTestCheckBoxCell : MedicalTest -> USet.Struct MedicalTest -> Html Msg
medicalTestCheckBoxCell targetTest selectedTests =
    let
        isChecked =
            USet.contains targetTest selectedTests

        testName =
            medicalTestName targetTest

        testId =
            "test_" ++ medicalTestToString targetTest
    in
        td [ class "medical-test" ]
            [ MDL.checkbox
                { inputId = testId, fieldLabel = testName }
                [ checked isChecked
                , onCheck <| onMedicalTestCheckEvent targetTest
                ]
            ]


selectedTestsCheckboxes : USet.Struct MedicalTest -> Html Msg
selectedTestsCheckboxes selectedTests =
    table [ class "setup-checkboxes" ]
        [ tr []
            [ medicalTestCheckBoxCell Bioquimico selectedTests
            , medicalTestCheckBoxCell Coproparasitario selectedTests
            ]
        , tr []
            [ medicalTestCheckBoxCell Examen selectedTests
            , medicalTestCheckBoxCell Hemograma selectedTests
            ]
        , tr []
            [ medicalTestCheckBoxCell Orina selectedTests
            , medicalTestCheckBoxCell Parasitologico selectedTests
            ]
        , tr []
            [ medicalTestCheckBoxCell Enzimatico selectedTests
            , medicalTestCheckBoxCell Hemostatico selectedTests
            ]
        , tr []
            [ medicalTestCheckBoxCell Serologico selectedTests
            , td [] []
            ]
        ]


selectedTestsRow : USet.Struct MedicalTest -> Html Msg
selectedTestsRow selectedTests =
    p [ class "setup-table" ]
        [ strong [ class "setup" ] [ text "Reportes:" ]
        , selectedTestsCheckboxes selectedTests
        ]


type alias SuggestionsConfig a =
    { hint : String
    , inputId : String
    , isFocused : Bool
    , maybeSuggestions : Maybe (SList.SelectList a)
    , onAutoCompleteKeyDown : AC.AutoCompleteKey -> Msg
    , onFocusChange : Bool -> Msg
    , onQueryTextInput : String -> Msg
    , queryText : String
    , suggestionItemView : SList.Position -> a -> Html Msg
    }


type alias CompleteItemConfig =
    { text : String
    , onDelete : Msg
    }


type AutoCompleteConfig a
    = Complete CompleteItemConfig
    | NeedsSuggestions (SuggestionsConfig a)


type alias AutoCompleteRowConfig a =
    { label : String
    , config : AutoCompleteConfig a
    }


patientAutoCompleteConfig : SetupModel -> AutoCompleteRowConfig Patient
patientAutoCompleteConfig model =
    let
        patientLabel =
            "Paciente:"
    in
        case model.currentPatient of
            KnownPatient patient ->
                { label = patientLabel
                , config =
                    Complete
                        { text = patient.name
                        , onDelete =
                            ResetPatient
                        }
                }

            UnknownPatient textFieldState ->
                { label = patientLabel
                , config =
                    NeedsSuggestions
                        { hint = "Nombre del paciente..."
                        , inputId = "patient-input"
                        , isFocused = textFieldState.hasFocus
                        , maybeSuggestions = model.suggestedPatients
                        , onAutoCompleteKeyDown = onPatientACKeysPressed
                        , onFocusChange = TextFocusChange PatientSetup
                        , onQueryTextInput = TextChange PatientSetup
                        , queryText = textFieldState.value
                        , suggestionItemView = suggestedPatientRow
                        }
                }


doctorAutoCompleteConfig : SetupModel -> AutoCompleteRowConfig Doctor
doctorAutoCompleteConfig model =
    let
        doctorLabel =
            "Medico:"
    in
        case model.currentDoctor of
            KnownDoctor doctor ->
                { label = doctorLabel
                , config = Complete { text = doctor.name, onDelete = ResetDoctor }
                }

            UnknownDoctor textFieldState ->
                { label = doctorLabel
                , config =
                    NeedsSuggestions
                        { hint = "Nombre del medico..."
                        , inputId = "doctor-input"
                        , isFocused = textFieldState.hasFocus
                        , maybeSuggestions = model.suggestedDoctors
                        , onAutoCompleteKeyDown = onDoctorACKeysPressed
                        , onQueryTextInput = TextChange DoctorSetup
                        , onFocusChange = TextFocusChange DoctorSetup
                        , queryText = textFieldState.value
                        , suggestionItemView = suggestedDoctorRow
                        }
                }


completeItemView : CompleteItemConfig -> Html Msg
completeItemView config =
    div [ class "setup-input setup-chip-container" ]
        [ MDL.deletableChip
            { text = config.text
            , onClick = config.onDelete
            }
        ]


autoCompleteRow : AutoCompleteRowConfig a -> Html Msg
autoCompleteRow rowConfig =
    let
        labelView =
            strong [ class "setup" ] [ text rowConfig.label ]

        inputView =
            case rowConfig.config of
                Complete config ->
                    completeItemView config

                NeedsSuggestions config ->
                    autoCompleteInput config
    in
        p [ class "setup-autocomplete" ]
            [ labelView
            , inputView
            ]


startButton : Html Msg
startButton =
    div [] [ MDL.mainButton { text = "Comenzar", onClick = NoOp } ]


view : SetupModel -> Html Msg
view model =
    div []
        [ h1 []
            [ text "Nuevo Examen" ]
        , div [ class "center" ]
            [ autoCompleteRow <| patientAutoCompleteConfig model
            , autoCompleteRow <| doctorAutoCompleteConfig model
            , selectedTestsRow model.selectedTests
            ]
        , startButton
        ]
