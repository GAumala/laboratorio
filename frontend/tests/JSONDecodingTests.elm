module JSONDecodingTests exposing (..)

import Test exposing (..)
import Expect
import Model exposing (Doctor)
import JSONDecoding exposing (decodeDoctorSuggestions)
import Json.Decode exposing (decodeString)


suggestDoctorsResponse =
    "[{\"email\":\"alberto@gmail.com\",\"rowid\":1,\"name\":\"Alberto Sanchez\"},{\"email\":\"nelly@gmail.com\",\"rowid\":2,\"name\":\"Nelly Ortega\"}]"


all : Test
all =
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
