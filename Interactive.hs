module Interactive (
    activate
) where

import Types
import Data.List
import Control.Monad (forever)

import qualified Helper

-- | Private Variables
cursor :: String
cursor = ">>"

commandList :: [String]
commandList = ["help", "setTitle"]

-- | Public Functions
activate :: IO ()
activate = do
    let loop = True
    putStrLn "[?] Interactive mode activated. Type \"help\" for command list.\n"

    forever $ do
        putStr cursor
        command <- getLine
        
        processCommand command
    where
        processCommand :: String
                       ->  IO ()
        processCommand cmd = do
            if isCommand cmd then
                case cmd' of
                    "help"     -> cmdHelp
                    "setTitle" -> cmdSetTitle $ unwords . extractParams $ cmd
                    _          -> error "activate -> processCommand: Something got wrong."
            else
                putStrLn "Command not found.\n"
            where
                cmdHelp :: IO ()
                cmdHelp = do
                    putStrLn "Aviable Commands: "
                    mapM_ (\x -> putStrLn $ "-" ++ x) commandList
                    putStr "\n"
                    return ()

                cmdSetTitle :: String 
                            ->   IO ()
                cmdSetTitle title = do
                    putStrLn $ "Yayın başlığı \""++ title ++"\" olarak değiştirildi."
                    putStr "\n"
                    return ()

                cmd' = getCommand cmd

-- | Private Functions
isCommand     :: String 
              ->   Bool
isCommand text =
    Helper.numToBool . length $ filter (\x -> re_text `isInfixOf` x) commandList
    where
        re_text = getCommand text

getCommand    :: String 
              -> String
getCommand text
    | isHaveParams text = head . words $ text
    | otherwise         = text

isHaveParams  :: String 
              ->   Bool
isHaveParams text = 
    Helper.numToBool $ (length $ words $ text) - 1

extractParams ::   String 
              -> [String]
extractParams text
    | isHaveParams text = extractParams' text
    | otherwise         = []
    where
        extractParams' text = tail . words $ text
