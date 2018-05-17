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
            , ResetDoctor
            , ResetPatient
            , TextChange
            , TextFocusChange
            )
        , Doctor
        , HemogramaModel
        , Patient
        , CurrentDoctor(KnownDoctor, UnknownDoctor)
        , CurrentPatient(KnownPatient, UnknownPatient)
        , Section
            ( SetupS
            , BioquimicoS
            , CoproparasitarioS
            , EnzimaticoS
            , ExamenS
            , HemogramaS
            , HemostaticoS
            , OrinaS
            , ParasitologicoS
            , SerologicoS
            , FinishS
            )
        , TextFieldState
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
        , SetupModel
        )

import Dict
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


type alias TextFieldState =
    { value : String, hasFocus : Bool }


type CurrentPatient
    = UnknownPatient TextFieldState
    | KnownPatient Patient


type CurrentDoctor
    = UnknownDoctor TextFieldState
    | KnownDoctor Doctor


type alias SetupModel =
    { currentPatient : CurrentPatient
    , currentDoctor : CurrentDoctor
    , suggestedDoctors : Maybe (SList.SelectList Doctor)
    , suggestedPatients : Maybe (SList.SelectList Patient)
    , selectedTests : USet.Struct MedicalTest
    }


type alias HemogramaModel =
    { textFields : Dict.Dict String TextFieldState
    }


type Section
    = SetupS
    | BioquimicoS
    | CoproparasitarioS
    | EnzimaticoS
    | ExamenS
    | HemogramaS
    | HemostaticoS
    | OrinaS
    | ParasitologicoS
    | SerologicoS
    | FinishS


type alias Model =
    { setupModel : SetupModel
    , hemogramaModel : HemogramaModel
    , sections : SList.SelectList Section
    }


type Msg
    = CheckTest MedicalTest
    | UncheckTest MedicalTest
    | NewDoctorSuggestions (Result Http.Error (List Doctor))
    | NewPatientSuggestions (Result Http.Error (List Patient))
    | ChangeFocusedDoctor Bool
    | ChangeFocusedPatient Bool
    | CommitDoctor
    | CommitPatient
    | ResetDoctor
    | ResetPatient
    | TextChange String String
    | TextFocusChange String Bool
    | NoOp
