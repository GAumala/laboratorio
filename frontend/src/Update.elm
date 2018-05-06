module Update exposing (update)

import Model
    exposing
        ( Model
        , Doctor
        , Msg
            ( ChangeFocusedDoctor
            , ChangeFocusedPatient
            , CheckTest
            , CommitDoctor
            , CommitPatient
            , NewDoctorSuggestions
            , NewPatientSuggestions
            , UncheckTest
            , ResetDoctor
            , ResetPatient
            , TextChange
            , TextFocusChange
            )
        , CurrentDoctor(UnknownDoctor)
        , CurrentPatient(UnknownPatient)
        , TextFieldId(DoctorSetup, PatientSetup)
        )
import Model.Transforms
    exposing
        ( addSelectedTest
        , commitToFocusedDoctor
        , commitToFocusedPatient
        , moveFocusedDoctor
        , moveFocusedPatient
        , removeSelectedTest
        , resetDoctor
        , resetPatient
        , setDoctorSuggestions
        , setDoctorQueryText
        , setDoctorTextFocus
        , setPatientSuggestions
        , setPatientQueryText
        , setPatientTextFocus
        )
import API exposing (getPatientSuggestions, getDoctorSuggestions)


baseUrl : String
baseUrl =
    ""


updateTextValue : TextFieldId -> String -> Model -> ( Model, Cmd Msg )
updateTextValue textFieldId newValue model =
    case textFieldId of
        DoctorSetup ->
            ( setDoctorQueryText newValue model
            , getDoctorSuggestions baseUrl
                newValue
            )

        PatientSetup ->
            ( setPatientQueryText newValue model
            , getPatientSuggestions baseUrl
                newValue
            )


updateTextFocusState : TextFieldId -> Bool -> Model -> ( Model, Cmd Msg )
updateTextFocusState textFieldId newValue model =
    case textFieldId of
        DoctorSetup ->
            ( setDoctorTextFocus newValue model
            , Cmd.none
            )

        PatientSetup ->
            ( setPatientTextFocus newValue model
            , Cmd.none
            )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CheckTest testToAdd ->
            ( addSelectedTest testToAdd model, Cmd.none )

        UncheckTest testToRemove ->
            ( removeSelectedTest testToRemove model, Cmd.none )

        NewDoctorSuggestions response ->
            case response of
                Ok suggestions ->
                    ( setDoctorSuggestions suggestions model, Cmd.none )

                Err error ->
                    ( model, Cmd.none )

        NewPatientSuggestions response ->
            case response of
                Ok suggestions ->
                    ( setPatientSuggestions suggestions model, Cmd.none )

                Err error ->
                    ( model, Cmd.none )

        TextChange textFieldId value ->
            updateTextValue textFieldId value model

        TextFocusChange textFieldId value ->
            updateTextFocusState textFieldId value model

        ChangeFocusedDoctor isUp ->
            ( moveFocusedDoctor isUp model, Cmd.none )

        ChangeFocusedPatient isUp ->
            ( moveFocusedPatient isUp model, Cmd.none )

        CommitDoctor ->
            ( commitToFocusedDoctor model, Cmd.none )

        CommitPatient ->
            ( commitToFocusedPatient model, Cmd.none )

        ResetDoctor ->
            ( resetDoctor model, Cmd.none )

        ResetPatient ->
            ( resetPatient model, Cmd.none )

        _ ->
            ( model, Cmd.none )
