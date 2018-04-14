module Init exposing (defaultModel, init)

import Model
    exposing
        ( Model
        , Msg
        , CurrentPatient(UnknownPatient)
        , CurrentDoctor(UnknownDoctor)
        )
import UStruct.USet as USet


defaultModel : Model
defaultModel =
    { currentPatient = UnknownPatient ""
    , currentDoctor = UnknownDoctor ""
    , selectedTests = USet.empty
    }


init : ( Model, Cmd Msg )
init =
    ( defaultModel, Cmd.none )
