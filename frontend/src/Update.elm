module Update exposing (update)

import Model
    exposing
        ( Model
        , Doctor
        , Msg
            ( CheckTest
            , UncheckTest
            , SuggestDoctors
            , SetDoctor
            , ChangeFocusedDoctor
            , CommitDoctor
            )
        , CurrentDoctor(UnknownDoctor)
        , CurrentPatient(UnknownPatient)
        )
import Model.Transforms
    exposing
        ( addSelectedTest
        , removeSelectedTest
        , setDoctorSuggestions
        , moveFocusedDoctor
        , commitToFocusedDoctor
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CheckTest testToAdd ->
            ( addSelectedTest testToAdd model, Cmd.none )

        UncheckTest testToRemove ->
            ( removeSelectedTest testToRemove model, Cmd.none )

        SuggestDoctors queryString ->
            ( setDoctorSuggestions queryString model, Cmd.none )

        ChangeFocusedDoctor isUp ->
            ( moveFocusedDoctor isUp model, Cmd.none )

        CommitDoctor ->
            ( commitToFocusedDoctor model, Cmd.none )

        _ ->
            ( model, Cmd.none )
