module Model
    exposing
        ( Model
        , Msg
            ( CheckTest
            , UncheckTest
            , SuggestDoctors
            , SetDoctor
            , ChangeFocusedDoctor
            , NoOp
            , CommitDoctor
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
        )

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
    , selectedTests : USet.Struct MedicalTest
    }


type Msg
    = CheckTest MedicalTest
    | UncheckTest MedicalTest
    | SuggestDoctors String
    | SetDoctor Doctor
    | ChangeFocusedDoctor Bool
    | CommitDoctor
    | NoOp
