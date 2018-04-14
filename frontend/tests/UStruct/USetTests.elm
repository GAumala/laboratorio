module UStruct.USetTests exposing (..)

import Test exposing (..)
import Expect
import UStruct.USet as USet


-- Check out http://package.elm-lang.org/packages/elm-community/elm-test/latest to learn more about testing in Elm!


type MyUnion
    = One
    | Two
    | Three
    | Four
    | Five


all : Test
all =
    describe "USet"
        [ test "should be able to add elements" <|
            \_ ->
                let
                    set =
                        USet.empty |> USet.add Two
                in
                    Expect.true "Expected set to contain element 'Two'" <| USet.contains Two set
        , test "should be able to remove added elements" <|
            \_ ->
                let
                    set =
                        USet.empty |> USet.add Two |> USet.remove Two
                in
                    Expect.false "Expected set to NOT contain element 'Two'" <| USet.contains Two set
        ]
