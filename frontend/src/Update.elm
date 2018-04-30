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
            , SuggestDoctors
            , SuggestPatients
            )
        , CurrentDoctor(UnknownDoctor)
        , CurrentPatient(UnknownPatient)
        )
import Model.Transforms
    exposing
        ( addSelectedTest
        , removeSelectedTest
        , setDoctorSuggestions
        , setDoctorQueryText
        , setPatientSuggestions
        , setPatientQueryText
        , moveFocusedDoctor
        , commitToFocusedDoctor
        , moveFocusedPatient
        , commitToFocusedPatient
        )
import API exposing (getPatientSuggestions, getDoctorSuggestions)


baseUrl : String
baseUrl =
    ""


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

        SuggestDoctors queryText ->
            ( setDoctorQueryText queryText model
            , getDoctorSuggestions baseUrl
                queryText
            )

        NewPatientSuggestions response ->
            case response of
                Ok suggestions ->
                    ( setPatientSuggestions suggestions model, Cmd.none )

                Err error ->
                    ( model, Cmd.none )

        SuggestPatients queryText ->
            ( setPatientQueryText queryText model
            , getPatientSuggestions baseUrl
                queryText
            )

        ChangeFocusedDoctor isUp ->
            ( moveFocusedDoctor isUp model, Cmd.none )

        CommitDoctor ->
            ( commitToFocusedDoctor model, Cmd.none )

        ChangeFocusedPatient isUp ->
            ( moveFocusedPatient isUp model, Cmd.none )

        CommitPatient ->
            ( commitToFocusedPatient model, Cmd.none )

        _ ->
            ( model, Cmd.none )
