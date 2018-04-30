module JSONDecodingTests exposing (..)

import Test exposing (..)
import Expect
import Model exposing (Doctor)
import Model.JSONDecoding
    exposing
        ( decodeDoctorSuggestions
        , decodePatientSuggestions
        )
import Json.Decode exposing (decodeString)


suggestDoctorsResponse =
    "[{\"email\":\"alberto@gmail.com\",\"rowid\":1,\"name\":\"Alberto Sanchez\"},{\"email\":\"nelly@gmail.com\",\"rowid\":2,\"name\":\"Nelly Ortega\"}]"


suggestPatientsResponse =
    "[{\"email\":\"alex@gmail.com\",\"rowid\":1,\"name\":\"Alex Rivadeneira\"},{\"email\":\"joselyn@gmail.com\",\"rowid\":2,\"name\":\"Joselyn Fuentes\"}]"


decodeDoctorSuggestionsTest : Test
decodeDoctorSuggestionsTest =
    describe "decodeDoctorSuggestions"
        [ test "should decode an array of doctors" <|
            \_ ->
                let
                    result =
                        decodeString decodeDoctorSuggestions
                            suggestDoctorsResponse

                    expectedResult =
                        Ok
                            [ { rowid = 1
                              , name = "Alberto Sanchez"
                              , email = "alberto@gmail.com"
                              }
                            , { rowid = 2
                              , name = "Nelly Ortega"
                              , email = "nelly@gmail.com"
                              }
                            ]
                in
                    Expect.equal result expectedResult
        ]


decodePatientSuggestionsTest : Test
decodePatientSuggestionsTest =
    describe "decodePatientSuggestions"
        [ test "should decode an array of doctors" <|
            \_ ->
                let
                    result =
                        decodeString decodePatientSuggestions
                            suggestPatientsResponse

                    expectedResult =
                        Ok
                            [ { rowid = 1
                              , name = "Alex Rivadeneira"
                              , email = "alex@gmail.com"
                              }
                            , { rowid = 2
                              , name = "Joselyn Fuentes"
                              , email = "joselyn@gmail.com"
                              }
                            ]
                in
                    Expect.equal result expectedResult
        ]
