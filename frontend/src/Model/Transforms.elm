module Model.Transforms exposing (addSelectedTest, removeSelectedTest)

import UStruct.USet as USet
import Model exposing (Model, MedicalTest)


addSelectedTest : MedicalTest -> Model -> Model
addSelectedTest testToAdd model =
    { model
        | selectedTests =
            USet.add testToAdd model.selectedTests
    }


removeSelectedTest : MedicalTest -> Model -> Model
removeSelectedTest testToRemove model =
    { model
        | selectedTests =
            USet.remove testToRemove model.selectedTests
    }
