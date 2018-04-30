module UpdateTests exposing (..)

import Test exposing (..)
import Expect
import Model
    exposing
        ( MedicalTest(Hemograma)
        , Msg
            ( CheckTest
            , UncheckTest
            , SuggestDoctors
            , SuggestPatients
            )
        , CurrentDoctor(UnknownDoctor)
        , CurrentPatient(UnknownPatient)
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
                        ( { defaultModel
                            | selectedTests =
                                USet.fromList [ Hemograma ]
                          }
                        , Cmd.none
                        )
        , test "should remove selected tests with the UncheckTest msg" <|
            \_ ->
                let
                    model =
                        { defaultModel
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


suggestDoctorsMsg : Test
suggestDoctorsMsg =
    let
        ( modelAfterTyping, cmdIssuedAfterTyping ) =
            update (SuggestDoctors "do") defaultModel

        expectedModelAfterTyping =
            { defaultModel
                | currentDoctor = UnknownDoctor "do"
            }

        modelBeforeDeleting =
            { defaultModel
                | suggestedDoctors =
                    Just <| SList.fromLists [] testDoctor []
            }

        ( modelAfterDeleting, cmdIssuedAfterDeleting ) =
            update (SuggestDoctors "") modelBeforeDeleting
    in
        describe "SuggestDoctors"
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


suggestPatientsMsg : Test
suggestPatientsMsg =
    let
        ( modelAfterTyping, cmdIssuedAfterTyping ) =
            update (SuggestPatients "do") defaultModel

        expectedModelAfterTyping =
            { defaultModel
                | currentPatient = UnknownPatient "do"
            }

        modelBeforeDeleting =
            { defaultModel
                | suggestedPatients =
                    Just <| SList.fromLists [] testPatient []
            }

        ( modelAfterDeleting, cmdIssuedAfterDeleting ) =
            update (SuggestPatients "") modelBeforeDeleting
    in
        describe "SuggestPatients"
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
