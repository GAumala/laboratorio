module View exposing (view)

import UStruct.USet as USet
import Utils.SelectList as SList
import Model
    exposing
        ( Model
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
            , UncheckTest
            , SuggestDoctors
            , SuggestPatients
            , ChangeFocusedDoctor
            , CommitDoctor
            , ChangeFocusedPatient
            , CommitPatient
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
        , ul
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


viewDoctorSuggestions : Maybe (SList.SelectList Doctor) -> Html Msg
viewDoctorSuggestions maybeSuggestedDoctors =
    case maybeSuggestedDoctors of
        Just suggestedDoctors ->
            ul [ class "autocomplete-list" ] <|
                SList.toList <|
                    SList.mapBy suggestedDoctorRow suggestedDoctors

        Nothing ->
            div [] []


viewPatientSuggestions : Maybe (SList.SelectList Patient) -> Html Msg
viewPatientSuggestions maybeSuggestedPatients =
    case maybeSuggestedPatients of
        Just suggestedPatients ->
            ul [ class "autocomplete-list" ] <|
                SList.toList <|
                    SList.mapBy suggestedPatientRow suggestedPatients

        Nothing ->
            div [] []


doctorAutoComplete : String -> Maybe (SList.SelectList Doctor) -> Html Msg
doctorAutoComplete inputName maybeSuggestedDoctors =
    let
        doctorNameInput =
            MDL.textField
                { fieldLabel = "Doctor"
                , inputId = "input-doctor"
                }
                [ type_ "text"
                , name "doctor"
                , value inputName
                , onInput SuggestDoctors
                , AC.onAutoCompleteKeyDown onDoctorACKeysPressed
                ]

        maybeSuggestions =
            viewDoctorSuggestions maybeSuggestedDoctors
    in
        div [ class "autocomplete-menu" ] [ doctorNameInput, maybeSuggestions ]


patientAutoComplete : String -> Maybe (SList.SelectList Patient) -> Html Msg
patientAutoComplete inputName maybeSuggestedPatients =
    let
        patientNameInput =
            MDL.textField
                { fieldLabel = "Paciente"
                , inputId = "input-patient"
                }
                [ type_ "text"
                , name "patient"
                , value inputName
                , onInput SuggestPatients
                , AC.onAutoCompleteKeyDown onPatientACKeysPressed
                ]

        maybeSuggestions =
            viewPatientSuggestions maybeSuggestedPatients
    in
        div [ class "autocomplete-menu" ] [ patientNameInput, maybeSuggestions ]


doctorInputField : CurrentDoctor -> Maybe (SList.SelectList Doctor) -> Html Msg
doctorInputField currentDoctor maybeSuggestedDoctors =
    case currentDoctor of
        UnknownDoctor inputName ->
            doctorAutoComplete inputName maybeSuggestedDoctors

        KnownDoctor doctor ->
            a [] [ text doctor.name ]


patientInputField : CurrentPatient -> Maybe (SList.SelectList Patient) -> Html Msg
patientInputField currentPatient maybeSuggestedPatients =
    case currentPatient of
        UnknownPatient inputName ->
            patientAutoComplete inputName maybeSuggestedPatients

        KnownPatient patient ->
            a [] [ text patient.name ]


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
                [ type_ "checkbox"
                , checked isChecked
                , onCheck <| onMedicalTestCheckEvent targetTest
                ]
            ]


selectedTestsCheckBoxes : USet.Struct MedicalTest -> Html Msg
selectedTestsCheckBoxes selectedTests =
    table [ class "tests-table" ]
        [ tr []
            [ medicalTestCheckBoxCell Bioquimico selectedTests
            , medicalTestCheckBoxCell Coproparasitario selectedTests
            , medicalTestCheckBoxCell Enzimatico selectedTests
            ]
        , tr []
            [ medicalTestCheckBoxCell Examen selectedTests
            , medicalTestCheckBoxCell Hemograma selectedTests
            , medicalTestCheckBoxCell Hemostatico selectedTests
            ]
        , tr []
            [ medicalTestCheckBoxCell Orina selectedTests
            , medicalTestCheckBoxCell Parasitologico selectedTests
            , medicalTestCheckBoxCell Serologico selectedTests
            ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Nuevo Examen" ]
        , patientInputField model.currentPatient model.suggestedPatients
        , doctorInputField model.currentDoctor model.suggestedDoctors
        , br [] []
        , selectedTestsCheckBoxes model.selectedTests
        ]
