module Update exposing (update)

import Model
    exposing
        ( Model
        , Doctor
        , Msg
            ( ChangeFocusedDoctor
            , CheckTest
            , CommitDoctor
            , NewDoctorSuggestions
            , UncheckTest
            , SetDoctor
            , SuggestDoctors
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
        , moveFocusedDoctor
        , commitToFocusedDoctor
        )
import API exposing (getDoctorSuggestions)


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

        ChangeFocusedDoctor isUp ->
            ( moveFocusedDoctor isUp model, Cmd.none )

        CommitDoctor ->
            ( commitToFocusedDoctor model, Cmd.none )

        _ ->
            ( model, Cmd.none )
