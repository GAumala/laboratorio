module Model.Transforms
    exposing
        ( addSelectedTest
        , removeSelectedTest
        , setDoctorQueryText
        , setDoctorSuggestions
        , moveFocusedDoctor
        , commitToFocusedDoctor
        )

import String exposing (isEmpty)
import UStruct.USet as USet
import Utils.SelectList as SList
import Model
    exposing
        ( Doctor
        , CurrentDoctor(KnownDoctor, UnknownDoctor)
        , Model
        , MedicalTest
        )


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


setDoctorSuggestions : List Doctor -> Model -> Model
setDoctorSuggestions suggestedDoctors model =
    case suggestedDoctors of
        [] ->
            { model | suggestedDoctors = Nothing }

        x :: xs ->
            { model | suggestedDoctors = Just <| SList.fromLists [] x xs }


setDoctorQueryText : String -> Model -> Model
setDoctorQueryText queryText model =
    let
        suggestedDoctors =
            if isEmpty queryText then
                Nothing
            else
                model.suggestedDoctors
    in
        { model
            | currentDoctor = UnknownDoctor queryText
            , suggestedDoctors = suggestedDoctors
        }


moveFocusedItemDown : SList.SelectList a -> SList.SelectList a
moveFocusedItemDown selectList =
    SList.move 1 selectList


moveFocusedItemUp : SList.SelectList a -> SList.SelectList a
moveFocusedItemUp selectList =
    SList.move -1 selectList


moveFocusedDoctor : Bool -> Model -> Model
moveFocusedDoctor isUp model =
    let
        maybeSuggestedDoctors =
            model.suggestedDoctors

        newSuggestedDoctors =
            case maybeSuggestedDoctors of
                Just suggestedDoctors ->
                    if isUp then
                        Just <| moveFocusedItemUp suggestedDoctors
                    else
                        Just <| moveFocusedItemDown suggestedDoctors

                Nothing ->
                    Nothing
    in
        { model
            | suggestedDoctors = newSuggestedDoctors
        }


commitToFocusedDoctor : Model -> Model
commitToFocusedDoctor model =
    case model.suggestedDoctors of
        Just suggestedDoctors ->
            { model
                | currentDoctor = KnownDoctor <| SList.selected suggestedDoctors
                , suggestedDoctors = Nothing
            }

        Nothing ->
            model
