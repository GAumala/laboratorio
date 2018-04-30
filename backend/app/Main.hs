{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad.IO.Class (liftIO)
import Data.Aeson (ToJSON, object, (.=))
import qualified Data.Text.Lazy as T
import qualified Data.Text.Lazy.IO as IOT
import Web.Scotty (file, finish, get, json, param, rescue, setHeader, scotty, 
                    status, text, ActionM, Parsable, ScottyM)
import Web.Scotty.AutoComplete (autoCompleteWith)

import qualified Data.Doctor as Doctor
import qualified Data.Patient as Patient
import Lib


serveClientApp :: ActionM ()
serveClientApp = do
    setHeader "Content-Type" "text/html" 
    file "app.html" 


mockedSuggestedDoctors :: T.Text -> IO [Doctor.Record]
mockedSuggestedDoctors queryText = return
    [ Doctor.Record 
        { Doctor.rowid = 1
        , Doctor.name = "Alberto Sanchez"
        , Doctor.email = "sanchez@gmail.com" } 
    , Doctor.Record 
        { Doctor.rowid = 2
        , Doctor.name = "Nelly Ortega"
        , Doctor.email = "nelly@gmail.com" } ]

mockedSuggestedPatients :: T.Text -> IO [Patient.Record]
mockedSuggestedPatients queryText = return
    [ Patient.Record 
        { Patient.rowid = 1
        , Patient.name = "Alex Rivadeneira"
        , Patient.email = "alex@gmail.com" } 
    , Patient.Record 
        { Patient.rowid = 2
        , Patient.name = "Joselyn Fuentes"
        , Patient.email = "joselyn@gmail.com" } ]

runBackendServer :: ScottyM ()
runBackendServer = do
    get "/" serveClientApp
    get "/doctors" $ autoCompleteWith mockedSuggestedDoctors
    get "/patients" $ autoCompleteWith mockedSuggestedPatients

main :: IO ()
main = scotty 8008 runBackendServer
