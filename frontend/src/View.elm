module View exposing (view)

import List
import UStruct.USet as USet
import Model
    exposing
        ( Model
        , Doctor
        , CurrentPatient
            ( UnknownPatient
            , KnownPatient
            )
        , CurrentDoctor
            ( UnknownDoctor
            , KnownDoctor
            )
        , SuggestedDoctors
        , Msg
            ( CheckTest
            , UncheckTest
            , SetDoctor
            , SuggestDoctors
            , ChangeFocusedDoctor
            , CommitDoctor
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
        , li
        , ul
        , table
        , tr
        , td
        )
import Html.Attributes exposing (class, classList, checked, id, name, placeholder, type_, value)
import KeyboardEvents exposing (onKeyDown)
import Html.Events exposing (onCheck, onInput)


suggestedDoctorRow : Bool -> Doctor -> Html Msg
suggestedDoctorRow focused doctor =
    let
        classes =
            if focused then
                "autocomplete-item key-selected"
            else
                "autocomplete-item"
    in
        li [ class classes ] [ text doctor.name ]


onArrowKeysPressed : Int -> Msg
onArrowKeysPressed keyCode =
    case keyCode of
        38 ->
            ChangeFocusedDoctor True

        40 ->
            ChangeFocusedDoctor False

        13 ->
            CommitDoctor

        _ ->
            NoOp


viewDoctorSuggestions : Maybe SuggestedDoctors -> Html Msg
viewDoctorSuggestions maybeSuggestedDoctors =
    case maybeSuggestedDoctors of
        Just suggestedDoctors ->
            let
                createNormalRows =
                    List.map
                        (suggestedDoctorRow
                            False
                        )

                beforeRows =
                    createNormalRows suggestedDoctors.beforeList

                afterRows =
                    createNormalRows suggestedDoctors.afterList

                focusedRow =
                    [ suggestedDoctorRow True suggestedDoctors.focused
                    ]
            in
                ul [ class "autocomplete-list" ] <|
                    List.concat
                        [ beforeRows
                        , focusedRow
                        , afterRows
                        ]

        Nothing ->
            div [] []


doctorAutocomplete : String -> Maybe SuggestedDoctors -> Html Msg
doctorAutocomplete inputName maybeSuggestedDoctors =
    let
        doctorNameInput =
            input
                [ type_ "text"
                , placeholder "Doctor"
                , name "doctor"
                , value inputName
                , onInput SuggestDoctors
                , onKeyDown onArrowKeysPressed
                ]
                []

        maybeSuggestions =
            viewDoctorSuggestions maybeSuggestedDoctors
    in
        div [ class "autocomplete-menu" ] [ doctorNameInput, maybeSuggestions ]


patientInputField : CurrentPatient -> Html Msg
patientInputField currentPatient =
    case currentPatient of
        UnknownPatient inputName ->
            input
                [ type_ "text"
                , placeholder "paciente"
                , name "paciente"
                , value inputName
                ]
                []

        KnownPatient patient ->
            a [] [ text patient.name ]


doctorInputField : CurrentDoctor -> Maybe SuggestedDoctors -> Html Msg
doctorInputField currentDoctor maybeSuggestedDoctors =
    case currentDoctor of
        UnknownDoctor inputName ->
            doctorAutocomplete inputName maybeSuggestedDoctors

        KnownDoctor doctor ->
            a [] [ text doctor.name ]


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
    in
        td []
            [ input
                [ type_ "checkbox"
                , checked isChecked
                , onCheck <| onMedicalTestCheckEvent targetTest
                ]
                []
            , text testName
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
    form []
        [ h1 [] [ text "Your Elm App is working!" ]
        , patientInputField model.currentPatient
        , br [] []
        , doctorInputField model.currentDoctor model.suggestedDoctors
        , selectedTestsCheckBoxes model.selectedTests
        ]
