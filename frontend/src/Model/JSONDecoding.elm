module Model.JSONDecoding exposing (decodeDoctorSuggestions, decodePatientSuggestions)

import Json.Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (decode, required)
import Model exposing (Doctor, Patient)


decodeDoctor : Decoder Doctor
decodeDoctor =
    decode Doctor
        |> required "rowid" int
        |> required "name" string
        |> required "email" string


decodeDoctorSuggestions : Decoder (List Doctor)
decodeDoctorSuggestions =
    list decodeDoctor


decodePatient : Decoder Patient
decodePatient =
    decode Patient
        |> required "rowid" int
        |> required "name" string
        |> required "email" string


decodePatientSuggestions : Decoder (List Patient)
decodePatientSuggestions =
    list decodePatient
