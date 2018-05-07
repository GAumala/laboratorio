module UpdateTests exposing (..)

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


all : Test
all =
    describe "update"
        [ test "should add selected tests with the CheckTest msg" <|
            \_ ->
                let
                    updated =
                        update (CheckTest Hemograma) defaultModel
                in
                    Expect.equal
                        updated
                        ( fromSetupM <|
                            \m ->
                                { m
                                    | selectedTests =
                                        USet.fromList [ Hemograma ]
                                }
                        , Cmd.none
                        )
        , test "should remove selected tests with the UncheckTest msg" <|
            \_ ->
                let
                    model =
                        fromSetupM <|
                            \m ->
                                { m
                                    | selectedTests =
                                        USet.fromList [ Hemograma ]
                                }

                    updated =
                        update (UncheckTest Hemograma) model
                in
                    Expect.equal updated ( defaultModel, Cmd.none )
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


fromSetupM : (SetupModel -> SetupModel) -> Model
fromSetupM transform =
    { defaultModel | setupModel = transform defaultModel.setupModel }


suggestSetupDoctorTest : Test
suggestSetupDoctorTest =
    let
        typeTextAction =
            TextChange DoctorSetup "do"

        untypeTextAction =
            TextChange DoctorSetup ""

        ( modelAfterTyping, cmdIssuedAfterTyping ) =
            update typeTextAction defaultModel

        expectedModelAfterTyping =
            fromSetupM <|
                \m ->
                    { m
                        | currentDoctor =
                            UnknownDoctor
                                { value = "do", hasFocus = True }
                    }

        modelBeforeDeleting =
            fromSetupM <|
                \m ->
                    { m
                        | suggestedDoctors =
                            Just <| SList.fromLists [] testDoctor []
                    }

        ( modelAfterDeleting, cmdIssuedAfterDeleting ) =
            update untypeTextAction modelBeforeDeleting
    in
        describe "Suggest a doctor in setup"
            [ test "should send http request after typing" <|
                \_ -> Expect.notEqual cmdIssuedAfterTyping Cmd.none
            , test "should set typed text as current doctor's query text" <|
                \_ ->
                    Expect.equal
                        modelAfterTyping
                        expectedModelAfterTyping
            , test "should remove suggested doctors after deleting all text" <|
                \_ -> Expect.equal modelAfterDeleting defaultModel
            , test "should not send http request after deleting all text" <|
                \_ -> Expect.equal cmdIssuedAfterDeleting Cmd.none
            ]


suggestSetupPatientTest : Test
suggestSetupPatientTest =
    let
        typeTextAction =
            TextChange PatientSetup "do"

        untypeTextAction =
            TextChange PatientSetup ""

        ( modelAfterTyping, cmdIssuedAfterTyping ) =
            update typeTextAction defaultModel

        expectedModelAfterTyping =
            fromSetupM <|
                \m ->
                    { m
                        | currentPatient =
                            UnknownPatient
                                { value = "do"
                                , hasFocus = True
                                }
                    }

        modelBeforeDeleting =
            fromSetupM <|
                \m ->
                    { m
                        | suggestedPatients =
                            Just <| SList.fromLists [] testPatient []
                    }

        ( modelAfterDeleting, cmdIssuedAfterDeleting ) =
            update untypeTextAction modelBeforeDeleting
    in
        describe "Sugggest patient in setup"
            [ test "should send http request after typing" <|
                \_ -> Expect.notEqual cmdIssuedAfterTyping Cmd.none
            , test "should set typed text as current doctor's query text" <|
                \_ ->
                    Expect.equal
                        modelAfterTyping
                        expectedModelAfterTyping
            , test "should remove suggested doctors after deleting all text" <|
                \_ -> Expect.equal modelAfterDeleting defaultModel
            , test "should not send http request after deleting all text" <|
                \_ -> Expect.equal cmdIssuedAfterDeleting Cmd.none
            ]
