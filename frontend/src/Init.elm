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
    { currentPatient = UnknownPatient { value = "", hasFocus = False }
    , currentDoctor = UnknownDoctor { value = "", hasFocus = False }
    , selectedTests = USet.empty
    , suggestedDoctors = Nothing
    , suggestedPatients = Nothing
    }


init : ( Model, Cmd Msg )
init =
    ( defaultModel, Cmd.none )
