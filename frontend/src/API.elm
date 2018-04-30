module API exposing (getDoctorSuggestions, getPatientSuggestions)

import Http
import String exposing (isEmpty)
import Model exposing (Msg(NewDoctorSuggestions, NewPatientSuggestions))
import Model.JSONDecoding exposing (decodeDoctorSuggestions, decodePatientSuggestions)


getDoctorSuggestions : String -> String -> Cmd Msg
getDoctorSuggestions baseUrl queryText =
    let
        url =
            baseUrl ++ "/doctors?q=" ++ queryText

        request =
            Http.get url decodeDoctorSuggestions
    in
        if isEmpty queryText then
            Cmd.none
        else
            Http.send NewDoctorSuggestions request


getPatientSuggestions : String -> String -> Cmd Msg
getPatientSuggestions baseUrl queryText =
    let
        url =
            baseUrl ++ "/patients?q=" ++ queryText

        request =
            Http.get url decodePatientSuggestions
    in
        if isEmpty queryText then
            Cmd.none
        else
            Http.send NewPatientSuggestions request
