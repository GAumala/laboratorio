{-# LANGUAGE OverloadedStrings #-}

module Web.Scotty.AutoComplete (autoCompleteWith, AutoCompleteHandler) where 

import Control.Monad.IO.Class (liftIO)
import Data.Aeson (ToJSON)
import qualified Data.Text.Lazy as T
import Web.Scotty.RequestSanitization (IffyParam, iffyParam, sendUnprocessableEntityError)
import Web.Scotty (json, ActionM)
-- A type alias for all functions that do auto completion. A function that takes
-- some text as input and does some IO to return a list of possible suggestions. 
type AutoCompleteHandler a = T.Text -> IO [a]

-- Scotty handler for endpoints that try to autocomplete what the user types.
-- The convention is to send the input text in the query string using parameter
-- "q" so that the autocomplete handler can take it and return some suggestions.
autoCompleteWith :: ToJSON a => AutoCompleteHandler a -> ActionM ()
autoCompleteWith handler = do
    maybeQueryText <- iffyParam "q" :: ActionM (IffyParam T.Text)
    case maybeQueryText of
        Left errorMessage -> sendUnprocessableEntityError errorMessage
        Right queryText -> do
            suggestions <- liftIO $ handler queryText
            json suggestions


