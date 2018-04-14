module View exposing (view)

import UStruct.USet as USet
import Model
    exposing
        ( Model
        , CurrentPatient
            ( UnknownPatient
            , KnownPatient
            )
        , CurrentDoctor
            ( UnknownDoctor
            , KnownDoctor
            )
        , Msg(CheckTest, UncheckTest)
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
        , table
        , tr
        , td
        )
import Html.Attributes exposing (class, checked, name, placeholder, type_, value)
import Html.Events exposing (onCheck)
import Set exposing (Set, member)


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


doctorInputField : CurrentDoctor -> Html Msg
doctorInputField currentDoctor =
    case currentDoctor of
        UnknownDoctor inputName ->
            input
                [ type_ "text"
                , placeholder "doctor"
                , name "doctor"
                , value inputName
                ]
                []

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
        , doctorInputField model.currentDoctor
        , selectedTestsCheckBoxes model.selectedTests
        ]
