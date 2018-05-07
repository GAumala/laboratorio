module Init exposing (defaultModel, init)

import Model
    exposing
        ( Model
        , Msg
        , CurrentPatient(UnknownPatient)
        , CurrentDoctor(UnknownDoctor)
        , SetupModel
        , Section(SetupS)
        )
import UStruct.USet as USet
import Utils.SelectList as SList


defaultSetupModel : SetupModel
defaultSetupModel =
    { currentPatient = UnknownPatient { value = "", hasFocus = False }
    , currentDoctor = UnknownDoctor { value = "", hasFocus = False }
    , selectedTests = USet.empty
    , suggestedDoctors = Nothing
    , suggestedPatients = Nothing
    }


defaultModel : Model
defaultModel =
    { setupModel = defaultSetupModel
    , sections = SList.fromLists [] SetupS []
    }


init : ( Model, Cmd Msg )
init =
    ( defaultModel, Cmd.none )
