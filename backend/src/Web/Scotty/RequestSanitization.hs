{-# LANGUAGE OverloadedStrings #-}

module Web.Scotty.RequestSanitization (IffyParam, iffyParam, sendUnprocessableEntityError) where

import Data.Aeson (object, (.=))
import qualified Data.Text.Lazy as T
import Network.HTTP.Types.Status (unprocessableEntity422)
import Web.Scotty (json, param, rescue, status, Parsable, ActionM)

-- A parameter that may or may not be in the request. If the parameter does not
-- exist, use an error message of type T.Text.
type IffyParam a = Either T.Text a

-- attempt to get a parameter that may or may not be in the request. If it is
-- not there, return an error message generated by Scotty.
iffyParam :: Parsable a => T.Text -> ActionM (IffyParam a)
iffyParam name = 
    let
        getParam = fmap Right $ param name 
        handleError errorMessage = return $ Left errorMessage
    in
        getParam `rescue` handleError


sendUnprocessableEntityError :: T.Text -> ActionM ()
sendUnprocessableEntityError errorMessage = do
    status unprocessableEntity422
    json $ object [ "error" .= errorMessage ]