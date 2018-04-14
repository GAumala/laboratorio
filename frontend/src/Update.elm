module Update exposing (update)

import Model
    exposing
        ( Model
        , Msg(CheckTest, UncheckTest)
        , CurrentDoctor(UnknownDoctor)
        , CurrentPatient(UnknownPatient)
        )
import Model.Transforms exposing (addSelectedTest, removeSelectedTest)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CheckTest testToAdd ->
            ( addSelectedTest testToAdd model, Cmd.none )

        UncheckTest testToRemove ->
            ( removeSelectedTest testToRemove model, Cmd.none )
