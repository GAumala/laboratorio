module Model
    exposing
        ( Model
        , Msg
            ( ChangeFocusedDoctor
            , ChangeFocusedPatient
            , CheckTest
            , CommitDoctor
            , CommitPatient
            , NewDoctorSuggestions
            , NewPatientSuggestions
            , NoOp
            , UncheckTest
            , SuggestDoctors
            , SuggestPatients
            )
        , Doctor
        , Patient
        , CurrentDoctor(KnownDoctor, UnknownDoctor)
        , CurrentPatient(KnownPatient, UnknownPatient)
        , MedicalTest
            ( Bioquimico
            , Coproparasitario
            , Enzimatico
            , Examen
            , Hemograma
            , Hemostatico
            , Orina
            , Parasitologico
            , Serologico
            )
        , medicalTestName
        , medicalTestToString
        )

import Http as Http
import UStruct.USet as USet
import Utils.SelectList as SList


type alias Patient =
    { rowid : Int
    , name : String
    , email : String
    }


type alias Doctor =
    { rowid : Int
    , name : String
    , email : String
    }


type MedicalTest
    = Bioquimico
    | Coproparasitario
    | Enzimatico
    | Examen
    | Hemograma
    | Hemostatico
    | Orina
    | Parasitologico
    | Serologico


medicalTestName : MedicalTest -> String
medicalTestName test =
    case test of
        Bioquimico ->
            "Bioquímico"

        Coproparasitario ->
            "Coproparasitario"

        Enzimatico ->
            "Enzimático"

        Examen ->
            "Examen"

        Hemograma ->
            "Hemograma"

        Hemostatico ->
            "Hemostático"

        Orina ->
            "Orina"

        Parasitologico ->
            "Parasitológico"

        Serologico ->
            "Serológico"


medicalTestToString : MedicalTest -> String
medicalTestToString test =
    case test of
        Bioquimico ->
            "bioquimico"

        Coproparasitario ->
            "coproparasitario"

        Enzimatico ->
            "enzimatico"

        Examen ->
            "examen"

        Hemograma ->
            "hemograma"

        Hemostatico ->
            "hemostatico"

        Orina ->
            "orina"

        Parasitologico ->
            "parasitologico"

        Serologico ->
            "serologico"


type CurrentPatient
    = UnknownPatient String
    | KnownPatient Patient


type CurrentDoctor
    = UnknownDoctor String
    | KnownDoctor Doctor


type alias Model =
    { currentPatient : CurrentPatient
    , currentDoctor : CurrentDoctor
    , suggestedDoctors : Maybe (SList.SelectList Doctor)
    , suggestedPatients : Maybe (SList.SelectList Patient)
    , selectedTests : USet.Struct MedicalTest
    }


type Msg
    = CheckTest MedicalTest
    | UncheckTest MedicalTest
    | SuggestDoctors String
    | NewDoctorSuggestions (Result Http.Error (List Doctor))
    | SuggestPatients String
    | NewPatientSuggestions (Result Http.Error (List Patient))
    | ChangeFocusedDoctor Bool
    | ChangeFocusedPatient Bool
    | CommitDoctor
    | CommitPatient
    | NoOp
