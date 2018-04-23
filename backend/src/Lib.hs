module Lib
    ( someFunc
    ) where

someOtherFunc = do Nothing

someFunc :: IO ()
someFunc = putStrLn "someFunc"
