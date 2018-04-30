module API exposing (getDoctorSuggestions)

import Http
import String exposing (isEmpty)
import Model exposing (Msg(NewDoctorSuggestions))
import JSONDecoding exposing (decodeDoctorSuggestions)


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
