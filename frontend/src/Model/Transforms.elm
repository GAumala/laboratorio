module Model.Transforms
    exposing
        ( addSelectedTest
        , removeSelectedTest
        , setDoctorSuggestions
        , moveFocusedDoctor
        , commitToFocusedDoctor
        )

import List
import Maybe
import UStruct.USet as USet
import Model
    exposing
        ( Doctor
        , CurrentDoctor(KnownDoctor, UnknownDoctor)
        , Model
        , MedicalTest
        , SuggestedDoctors
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
                Just
                    { beforeList = []
                    , focused = firstPossibleDoctor
                    , afterList =
                        possibleDoctors
                    }
            else
                Nothing
    in
        { model
            | suggestedDoctors = suggestedDoctors
            , currentDoctor =
                UnknownDoctor queryString
        }


moveFocusedDoctorDown : SuggestedDoctors -> SuggestedDoctors
moveFocusedDoctorDown suggestedDoctors =
    let
        beforeList =
            suggestedDoctors.beforeList

        focused =
            suggestedDoctors.focused

        afterList =
            suggestedDoctors.afterList

        maybeNewFocusedDoctor =
            List.head afterList
    in
        case maybeNewFocusedDoctor of
            Just newFocusedDoctor ->
                { beforeList = beforeList ++ [ focused ]
                , focused = newFocusedDoctor
                , afterList =
                    Maybe.withDefault
                        []
                    <|
                        List.tail afterList
                }

            Nothing ->
                suggestedDoctors


moveFocusedDoctorUp : SuggestedDoctors -> SuggestedDoctors
moveFocusedDoctorUp suggestedDoctors =
    let
        beforeList =
            suggestedDoctors.beforeList

        focused =
            suggestedDoctors.focused

        afterList =
            suggestedDoctors.afterList

        reversedBeforeList =
            List.reverse beforeList

        maybeNewFocusedDoctor =
            List.head <| reversedBeforeList

        maybeNewBeforeList =
            List.tail reversedBeforeList
    in
        case maybeNewFocusedDoctor of
            Just newFocusedDoctor ->
                { beforeList =
                    Maybe.withDefault []
                        maybeNewBeforeList
                , focused = newFocusedDoctor
                , afterList =
                    [ focused ]
                        ++ afterList
                }

            Nothing ->
                suggestedDoctors


moveFocusedDoctor : Bool -> Model -> Model
moveFocusedDoctor isUp model =
    let
        maybeSuggestedDoctors =
            model.suggestedDoctors

        newSuggestedDoctors =
            case maybeSuggestedDoctors of
                Just suggestedDoctors ->
                    if isUp then
                        Just <| moveFocusedDoctorUp suggestedDoctors
                    else
                        Just <| moveFocusedDoctorDown suggestedDoctors

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
                | currentDoctor = KnownDoctor suggestedDoctors.focused
                , suggestedDoctors = Nothing
            }

        Nothing ->
            model
