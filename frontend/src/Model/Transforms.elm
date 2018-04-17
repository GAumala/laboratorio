module Model.Transforms
    exposing
        ( addSelectedTest
        , removeSelectedTest
        , setDoctorSuggestions
        , moveFocusedDoctor
        , commitToFocusedDoctor
        )

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


firstPossibleDoctor =
    { rowid = 2
    , name = "Sussy Corral"
    , email = "sussy@gmail.com"
    }


possibleDoctors : List Doctor
possibleDoctors =
    [ { rowid = 1
      , name = "Natilse Rondon"
      , email = "natilse@gmail.com"
      }
    , { rowid = 2
      , name = "Marco Albuja"
      , email = "marco@gmail.com"
      }
    ]


setDoctorSuggestions : String -> Model -> Model
setDoctorSuggestions queryString model =
    let
        suggestedDoctors =
            if queryString /= "" then
                Just <| SList.fromLists [] firstPossibleDoctor possibleDoctors
            else
                Nothing
    in
        { model
            | suggestedDoctors = suggestedDoctors
            , currentDoctor =
                UnknownDoctor queryString
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
