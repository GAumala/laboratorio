module Model.Transforms
    exposing
        ( addSelectedTest
        , commitToFocusedDoctor
        , commitToFocusedPatient
        , moveFocusedDoctor
        , moveFocusedPatient
        , removeSelectedTest
        , resetDoctor
        , resetPatient
        , setDoctorQueryText
        , setDoctorSuggestions
        , setDoctorTextFocus
        , setPatientQueryText
        , setPatientSuggestions
        , setPatientTextFocus
        )

import String exposing (isEmpty)
import UStruct.USet as USet
import Utils.SelectList as SList
import Model
    exposing
        ( Doctor
        , Patient
        , CurrentDoctor(KnownDoctor, UnknownDoctor)
        , CurrentPatient(KnownPatient, UnknownPatient)
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
            | currentDoctor =
                UnknownDoctor
                    { value = queryText
                    , hasFocus = True
                    }
            , suggestedDoctors = suggestedDoctors
        }


setPatientSuggestions : List Patient -> Model -> Model
setPatientSuggestions suggestedPatients model =
    case suggestedPatients of
        [] ->
            { model | suggestedPatients = Nothing }

        x :: xs ->
            { model | suggestedPatients = Just <| SList.fromLists [] x xs }


setPatientQueryText : String -> Model -> Model
setPatientQueryText queryText model =
    let
        suggestedPatients =
            if isEmpty queryText then
                Nothing
            else
                model.suggestedPatients
    in
        { model
            | currentPatient =
                UnknownPatient
                    { value = queryText
                    , hasFocus =
                        True
                    }
            , suggestedPatients = suggestedPatients
        }


moveFocusedItemDown : SList.SelectList a -> SList.SelectList a
moveFocusedItemDown selectList =
    SList.move 1 selectList


moveFocusedItemUp : SList.SelectList a -> SList.SelectList a
moveFocusedItemUp selectList =
    SList.move -1 selectList


moveFocusedItem :
    Bool
    -> Maybe (SList.SelectList a)
    -> Maybe (SList.SelectList a)
moveFocusedItem isUp maybeItems =
    case maybeItems of
        Just items ->
            if isUp then
                Just <| moveFocusedItemUp items
            else
                Just <| moveFocusedItemDown items

        Nothing ->
            Nothing


moveFocusedDoctor : Bool -> Model -> Model
moveFocusedDoctor isUp model =
    let
        maybeSuggestedDoctors =
            model.suggestedDoctors

        newSuggestedDoctors : Maybe (SList.SelectList Doctor)
        newSuggestedDoctors =
            moveFocusedItem isUp maybeSuggestedDoctors
    in
        { model
            | suggestedDoctors = newSuggestedDoctors
        }


moveFocusedPatient : Bool -> Model -> Model
moveFocusedPatient isUp model =
    let
        maybeSuggestedPatients =
            model.suggestedPatients

        newSuggestedPatients =
            moveFocusedItem isUp maybeSuggestedPatients
    in
        { model
            | suggestedPatients = newSuggestedPatients
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


commitToFocusedPatient : Model -> Model
commitToFocusedPatient model =
    case model.suggestedPatients of
        Just suggestedPatients ->
            { model
                | currentPatient = KnownPatient <| SList.selected suggestedPatients
                , suggestedPatients = Nothing
            }

        Nothing ->
            model


setPatientTextFocus : Bool -> Model -> Model
setPatientTextFocus hasFocus model =
    case model.currentPatient of
        UnknownPatient textFieldState ->
            { model
                | currentPatient =
                    UnknownPatient
                        { value =
                            textFieldState.value
                        , hasFocus = hasFocus
                        }
            }

        KnownPatient _ ->
            model


setDoctorTextFocus : Bool -> Model -> Model
setDoctorTextFocus hasFocus model =
    case model.currentDoctor of
        UnknownDoctor textFieldState ->
            { model
                | currentDoctor =
                    UnknownDoctor
                        { value =
                            textFieldState.value
                        , hasFocus = hasFocus
                        }
            }

        KnownDoctor _ ->
            model


resetDoctor : Model -> Model
resetDoctor model =
    { model | currentDoctor = UnknownDoctor { value = "", hasFocus = False } }


resetPatient : Model -> Model
resetPatient model =
    { model | currentPatient = UnknownPatient { value = "", hasFocus = False } }
