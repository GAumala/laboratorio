module UpdateTests exposing (..)

import Test exposing (..)
import Expect
import Model exposing (MedicalTest(Hemograma), Msg(CheckTest, UncheckTest))
import Update exposing (update)
import Init exposing (defaultModel)
import UStruct.USet as USet


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
