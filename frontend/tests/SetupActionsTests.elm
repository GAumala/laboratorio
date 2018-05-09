module SetupActionsTests exposing (..)

import Test exposing (..)
import Expect
import Model
    exposing
        ( MedicalTest(Hemograma)
        , Msg
            ( CheckTest
            , UncheckTest
            , TextChange
            , TextFocusChange
            )
        , CurrentDoctor(UnknownDoctor)
        , CurrentPatient(UnknownPatient)
        , Model
        , SetupModel
        , TextFieldId(DoctorSetup, PatientSetup)
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
                        update (TextChange DoctorSetup "riv") defaultModel

                    expectedModel =
                        modelWithDoctorQueryText
                in
                    \_ -> Expect.equal updatedModel expectedModel
            , test "after typing text should send cmd to fetch suggestions from server" <|
                let
                    ( _, issuedCmd ) =
                        update (TextChange DoctorSetup "riv") defaultModel
                in
                    \_ -> Expect.notEqual issuedCmd Cmd.none
            , test "after deleteing all typed text should update the model" <|
                let
                    ( updatedModel, _ ) =
                        update (TextChange DoctorSetup "") modelWithDoctorQueryText
                in
                    \_ -> Expect.equal updatedModel modelWithEmptyDoctorQueryText
            , test "after deleteing all typed text should not send any cmd" <|
                let
                    ( _, issuedCmd ) =
                        update (TextChange DoctorSetup "") modelWithDoctorQueryText
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
                        update (TextChange PatientSetup "riv") defaultModel

                    expectedModel =
                        modelWithPatientQueryText
                in
                    \_ -> Expect.equal updatedModel expectedModel
            , test "after typing text should send cmd to fetch suggestions from server" <|
                let
                    ( _, issuedCmd ) =
                        update (TextChange PatientSetup "riv") defaultModel
                in
                    \_ -> Expect.notEqual issuedCmd Cmd.none
            , test "after deleteing all typed text should update the model" <|
                let
                    ( updatedModel, _ ) =
                        update (TextChange PatientSetup "") modelWithPatientQueryText
                in
                    \_ -> Expect.equal updatedModel modelWithEmptyPatientQueryText
            , test "after deleteing all typed text should not send any cmd" <|
                let
                    ( _, issuedCmd ) =
                        update (TextChange PatientSetup "") modelWithPatientQueryText
                in
                    \_ -> Expect.equal issuedCmd Cmd.none
            ]
