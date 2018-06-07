module Interactive (
    activate
) where

import Types
import Control.Monad (forever)

-- | Private Variables
cursor :: String
cursor = ">>"

commandList :: [String]
commandList = ["info"]

-- | Public Functions
activate :: IO ()
activate = do
    putStrLn "[?] Interactive mode activated.\n"

    forever $ do
        putStr cursor
        command <- getLine
        
        processCommand command
    where
        processCommand :: String
                       ->  IO ()
        processCommand cmd = do
            case cmd of
                "info" -> putStrLn "test"
                _      -> return ()
