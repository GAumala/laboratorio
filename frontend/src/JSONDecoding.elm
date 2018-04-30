module JSONDecoding exposing (decodeDoctorSuggestions)

import Json.Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (decode, required)
import Model exposing (Doctor)


decodeDoctor : Decoder Doctor
decodeDoctor =
    decode Doctor
        |> required "rowid" int
        |> required "name" string
        |> required "email" string


decodeDoctorSuggestions : Decoder (List Doctor)
decodeDoctorSuggestions =
    list decodeDoctor
