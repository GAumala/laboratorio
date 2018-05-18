module SetupActionsTests exposing (..)

import Test exposing (..)
import Expect
import Model
    exposing
        ( MedicalTest(Hemograma)
        , Msg
            ( CheckTest
            , CommitDoctor
            , CommitPatient
            , UncheckTest
            , TextChange
            , TextFocusChange
            , NewDoctorSuggestions
            , NewPatientSuggestions
            , ResetDoctor
            , ResetPatient
            )
        , CurrentDoctor(UnknownDoctor, KnownDoctor)
        , CurrentPatient(UnknownPatient, KnownPatient)
        , Model
        , SetupModel
        )
import Update exposing (update)
import Init exposing (defaultModel)
import UStruct.USet as USet
import Utils.SelectList as SList


withNewSetupModel : (SetupModel -> SetupModel) -> Model
withNewSetupModel transform =
    { defaultModel | setupModel = transform defaultModel.setupModel }


checkMedicalTests : Test
checkMedicalTests =
    let
        modelWithHemogramaTestChecked =
            withNewSetupModel <|
                \m ->
                    { m
                        | selectedTests =
                            USet.fromList [ Hemograma ]
                    }

        modelWithZeroTestsChecked =
            withNewSetupModel <|
                \m ->
                    { m
                        | selectedTests =
                            USet.fromList []
                    }
    in
        describe "Selecting Medical tests"
            [ test "should add selected tests with the CheckTest msg" <|
                let
                    ( updatedModel, _ ) =
                        update (CheckTest Hemograma) defaultModel

                    expectedModel =
                        modelWithHemogramaTestChecked
                in
                    \_ -> Expect.equal updatedModel expectedModel
            , test "should remove selected tests with the UncheckTest msg" <|
                let
                    ( updatedModel, _ ) =
                        update (UncheckTest Hemograma) modelWithHemogramaTestChecked

                    expectedModel =
                        modelWithZeroTestsChecked
                in
                    \_ -> Expect.equal updatedModel expectedModel
            ]


testDoctor =
    { rowid = 1
    , name = "test"
    , email =
        "test@protonmail.com"
    }


testPatient =
    { rowid = 1
    , name = "test"
    , email =
        "test@protonmail.com"
    }


inputDoctorTests : Test
inputDoctorTests =
    let
        modelWithDoctorQueryText =
            withNewSetupModel <|
                \m ->
                    { m
                        | currentDoctor =
                            UnknownDoctor
                                { value = "riv"
                                , hasFocus = True
                                }
                    }

        modelWithEmptyDoctorQueryText =
            withNewSetupModel <|
                \m ->
                    { m
                        | currentDoctor =
                            UnknownDoctor
                                { value = ""
                                , hasFocus = True
                                }
                    }
    in
        describe "Inputting the assigned doctor"
            [ test "after typing text should update the model" <|
                let
                    ( updatedModel, _ ) =
                        update (TextChange "doctor-input" "riv") defaultModel

                    expectedModel =
                        modelWithDoctorQueryText
                in
                    \_ -> Expect.equal updatedModel expectedModel
            , test "after typing text should send cmd to fetch suggestions from server" <|
                let
                    ( _, issuedCmd ) =
                        update (TextChange "doctor-input" "riv") defaultModel
                in
                    \_ -> Expect.notEqual issuedCmd Cmd.none
            , test "after deleteing all typed text should update the model" <|
                let
                    ( updatedModel, _ ) =
                        update (TextChange "doctor-input" "") modelWithDoctorQueryText
                in
                    \_ -> Expect.equal updatedModel modelWithEmptyDoctorQueryText
            , test "after deleteing all typed text should not send any cmd" <|
                let
                    ( _, issuedCmd ) =
                        update (TextChange "doctor-input" "") modelWithDoctorQueryText
                in
                    \_ -> Expect.equal issuedCmd Cmd.none
            ]


inputPatientTests : Test
inputPatientTests =
    let
        modelWithPatientQueryText =
            withNewSetupModel <|
                \m ->
                    { m
                        | currentPatient =
                            UnknownPatient
                                { value = "riv"
                                , hasFocus = True
                                }
                    }

        modelWithEmptyPatientQueryText =
            withNewSetupModel <|
                \m ->
                    { m
                        | currentPatient =
                            UnknownPatient
                                { value = ""
                                , hasFocus = True
                                }
                    }
    in
        describe "Inputting the report's patient"
            [ test "after typing text should update the model" <|
                let
                    ( updatedModel, _ ) =
                        update (TextChange "patient-input" "riv") defaultModel

                    expectedModel =
                        modelWithPatientQueryText
                in
                    \_ -> Expect.equal updatedModel expectedModel
            , test "after typing text should send cmd to fetch suggestions from server" <|
                let
                    ( _, issuedCmd ) =
                        update (TextChange "patient-input" "riv") defaultModel
                in
                    \_ -> Expect.notEqual issuedCmd Cmd.none
            , test "after deleteing all typed text should update the model" <|
                let
                    ( updatedModel, _ ) =
                        update (TextChange "patient-input" "") modelWithPatientQueryText
                in
                    \_ -> Expect.equal updatedModel modelWithEmptyPatientQueryText
            , test "after deleteing all typed text should not send any cmd" <|
                let
                    ( _, issuedCmd ) =
                        update (TextChange "patient-input" "") modelWithPatientQueryText
                in
                    \_ -> Expect.equal issuedCmd Cmd.none
            ]


managingDoctorSuggestionsTests : Test
managingDoctorSuggestionsTests =
    let
        nonEmptyOkResult =
            Ok [ testDoctor ]

        emptyOkResult =
            Ok []

        modelWithOneSuggestedDoctor =
            withNewSetupModel <|
                \m ->
                    { m
                        | suggestedDoctors =
                            Just <| SList.fromLists [] testDoctor []
                    }

        modelWithNothingSuggestions =
            withNewSetupModel <|
                \m ->
                    { m
                        | suggestedDoctors = Nothing
                    }

        modelWithKnownDoctor =
            withNewSetupModel <|
                \m ->
                    { m
                        | currentDoctor = KnownDoctor testDoctor
                        , suggestedDoctors = Nothing
                    }
    in
        describe "Managing doctor suggestions"
            [ describe "Receiving a list of doctor suggestions via NewDoctorSuggestions"
                [ test "if the list is NOT empty, should replace the current suggestedDoctors" <|
                    let
                        ( updatedModel, _ ) =
                            update (NewDoctorSuggestions <| nonEmptyOkResult) defaultModel

                        expectedModel =
                            modelWithOneSuggestedDoctor
                    in
                        \_ -> Expect.equal updatedModel expectedModel
                , test "if the list is empty, should set suggestedDoctors as Nothing" <|
                    let
                        ( updatedModel, _ ) =
                            update (NewDoctorSuggestions <| emptyOkResult) modelWithOneSuggestedDoctor

                        expectedModel =
                            modelWithNothingSuggestions
                    in
                        \_ -> Expect.equal updatedModel expectedModel
                ]
            , describe "Choosing a suggestion With CommitDoctor"
                [ test "Should remove the suggestions and set a KnownDoctor as currentDoctor" <|
                    let
                        ( updatedModel, _ ) =
                            update CommitDoctor modelWithOneSuggestedDoctor

                        expectedModel =
                            modelWithKnownDoctor
                    in
                        \_ -> Expect.equal updatedModel expectedModel
                ]
            , describe "Clearing the selected doctor with ResetDoctor"
                [ test "Should replace the currentDoctor with an empty UnknownDoctor" <|
                    let
                        ( updatedModel, _ ) =
                            update ResetDoctor modelWithKnownDoctor

                        expectedModel =
                            modelWithNothingSuggestions
                    in
                        \_ -> Expect.equal updatedModel expectedModel
                ]
            ]


managingPatientSuggestionsTests : Test
managingPatientSuggestionsTests =
    let
        nonEmptyOkResult =
            Ok [ testPatient ]

        emptyOkResult =
            Ok []

        modelWithOneSuggestedPatient =
            withNewSetupModel <|
                \m ->
                    { m
                        | suggestedPatients =
                            Just <| SList.fromLists [] testPatient []
                    }

        modelWithNothingSuggestions =
            withNewSetupModel <|
                \m ->
                    { m
                        | suggestedPatients = Nothing
                    }

        modelWithKnownPatient =
            withNewSetupModel <|
                \m ->
                    { m
                        | currentPatient = KnownPatient testPatient
                        , suggestedPatients = Nothing
                    }
    in
        describe "Managing patient suggestions"
            [ describe "Receiving a list of patient suggestions via NewPatientSuggestions"
                [ test "if the list is NOT empty, should replace the current suggestedPatients" <|
                    let
                        ( updatedModel, _ ) =
                            update (NewPatientSuggestions <| nonEmptyOkResult) defaultModel

                        expectedModel =
                            modelWithOneSuggestedPatient
                    in
                        \_ -> Expect.equal updatedModel expectedModel
                , test "if the list is empty, should set suggestedPatients as Nothing" <|
                    let
                        ( updatedModel, _ ) =
                            update (NewPatientSuggestions <| emptyOkResult) modelWithOneSuggestedPatient

                        expectedModel =
                            modelWithNothingSuggestions
                    in
                        \_ -> Expect.equal updatedModel expectedModel
                ]
            , describe "Choosing a suggestion With CommitPatient"
                [ test "Should remove the suggestions and set a KnownPatient as currentPatient" <|
                    let
                        ( updatedModel, _ ) =
                            update CommitPatient modelWithOneSuggestedPatient

                        expectedModel =
                            modelWithKnownPatient
                    in
                        \_ -> Expect.equal updatedModel expectedModel
                ]
            , describe "Clearing the selected patient with ResetPatient"
                [ test "Should replace the currentPatient with an empty UnknownPatient" <|
                    let
                        ( updatedModel, _ ) =
                            update ResetPatient modelWithKnownPatient

                        expectedModel =
                            modelWithNothingSuggestions
                    in
                        \_ -> Expect.equal updatedModel expectedModel
                ]
            ]
