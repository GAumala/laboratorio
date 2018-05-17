module Update exposing (update)

import String
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
        , SetupModel
        )
import Model.SetupTransforms
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
import Model.HemogramaTransforms exposing (setHemogramaText, setHemogramaTextFocus)
import API exposing (getPatientSuggestions, getDoctorSuggestions)


baseUrl : String
baseUrl =
    ""


updateTextValue : String -> String -> Model -> ( Model, Cmd Msg )
updateTextValue textFieldId newValue model =
    let
        updateSetupM transform =
            { model | setupModel = transform model.setupModel }

        updateHemogramaM transform =
            { model | hemogramaModel = transform model.hemogramaModel }
    in
        case textFieldId of
            "doctor-input" ->
                ( setDoctorQueryText newValue |> updateSetupM
                , getDoctorSuggestions baseUrl
                    newValue
                )

            "patient-input" ->
                ( setPatientQueryText newValue |> updateSetupM
                , getPatientSuggestions baseUrl
                    newValue
                )

            _ ->
                if String.startsWith "hemograma-" textFieldId then
                    ( setHemogramaText textFieldId newValue |> updateHemogramaM, Cmd.none )
                else
                    ( model, Cmd.none )


updateTextFocusState : String -> Bool -> Model -> ( Model, Cmd Msg )
updateTextFocusState textFieldId newValue model =
    let
        updateSetupM transform =
            { model | setupModel = transform model.setupModel }

        updateHemogramaM transform =
            { model | hemogramaModel = transform model.hemogramaModel }
    in
        case textFieldId of
            "doctor-input" ->
                ( setDoctorTextFocus newValue |> updateSetupM
                , Cmd.none
                )

            "patient-input" ->
                ( setPatientTextFocus newValue |> updateSetupM
                , Cmd.none
                )

            _ ->
                if String.startsWith "hemograma-" textFieldId then
                    ( setHemogramaTextFocus textFieldId newValue |> updateHemogramaM, Cmd.none )
                else
                    ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        updateSetupM transform =
            { model | setupModel = transform model.setupModel }
    in
        case msg of
            CheckTest testToAdd ->
                ( addSelectedTest testToAdd |> updateSetupM, Cmd.none )

            UncheckTest testToRemove ->
                ( removeSelectedTest testToRemove |> updateSetupM, Cmd.none )

            NewDoctorSuggestions response ->
                case response of
                    Ok suggestions ->
                        ( setDoctorSuggestions suggestions |> updateSetupM, Cmd.none )

                    Err error ->
                        ( model, Cmd.none )

            NewPatientSuggestions response ->
                case response of
                    Ok suggestions ->
                        ( setPatientSuggestions suggestions |> updateSetupM, Cmd.none )

                    Err error ->
                        ( model, Cmd.none )

            TextChange textFieldId value ->
                updateTextValue textFieldId value model

            TextFocusChange textFieldId value ->
                updateTextFocusState textFieldId value model

            ChangeFocusedDoctor isUp ->
                ( moveFocusedDoctor isUp |> updateSetupM, Cmd.none )

            ChangeFocusedPatient isUp ->
                ( moveFocusedPatient isUp |> updateSetupM, Cmd.none )

            CommitDoctor ->
                ( commitToFocusedDoctor |> updateSetupM, Cmd.none )

            CommitPatient ->
                ( commitToFocusedPatient |> updateSetupM, Cmd.none )

            ResetDoctor ->
                ( resetDoctor |> updateSetupM, Cmd.none )

            ResetPatient ->
                ( resetPatient |> updateSetupM, Cmd.none )

            _ ->
                ( model, Cmd.none )
