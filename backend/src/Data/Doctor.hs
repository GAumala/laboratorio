{-# LANGUAGE DeriveGeneric #-}

module Data.Doctor (Record(Record), rowid, name, email) where

import Data.Aeson (FromJSON, ToJSON)
import qualified Data.Text.Lazy as T
import GHC.Generics

data Record = Record {
    rowid :: Int,
    name :: T.Text,
    email :: T.Text
} deriving (Show, Eq, Generic)

instance ToJSON Record
instance FromJSON Record
