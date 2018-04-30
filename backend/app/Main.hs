{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad.IO.Class (liftIO)
import Data.Aeson (object, (.=))
import qualified Data.Doctor as Doctor
import qualified Data.Text.Lazy as T
import qualified Data.Text.Lazy.IO as IOT
import Network.HTTP.Types.Status (unprocessableEntity422)
import Web.Scotty (file, finish, get, json, param, rescue, setHeader, scotty, 
                    status, text, ActionM, Parsable, ScottyM)
import Lib

type IffyParam a = Either T.Text a

iffyParam :: Parsable a => T.Text -> ActionM (IffyParam a)
iffyParam name = 
    let
        getParam = fmap Right $ param name 
        handleError errorMessage = return $ Left errorMessage
    in
        getParam `rescue` handleError

serveClientApp :: ActionM ()
serveClientApp = do
    setHeader "Content-Type" "text/html" 
    file "app.html" 

handleInvalidRequest :: T.Text -> ActionM ()
handleInvalidRequest errorMessage = do
    status unprocessableEntity422
    json $ object [ "error" .= errorMessage ]

mockedSuggestedDoctors :: [Doctor.Record]
mockedSuggestedDoctors = 
    [ Doctor.Record 
        { Doctor.rowid = 1
        , Doctor.name = "Alberto Sanchez"
        , Doctor.email = "sanchez@gmail.com" } 
    , Doctor.Record 
        { Doctor.rowid = 2
        , Doctor.name = "Nelly Ortega"
        , Doctor.email = "nelly@gmail.com" } ]

suggestDoctors :: ActionM ()
suggestDoctors = do
    maybeQueryText <- iffyParam "q" 
    case maybeQueryText of
        Left errorMessage -> handleInvalidRequest errorMessage
        Right queryText -> do
            setHeader "Content-Type" "application/json"
            json mockedSuggestedDoctors

runBackendServer :: ScottyM ()
runBackendServer = do
    get "/" serveClientApp
    get "/doctors" suggestDoctors 

main :: IO ()
main = scotty 8008 runBackendServer
