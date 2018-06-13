module Interactive (
    activate
) where

import Types
import Data.List
import Control.Monad (forever)

import qualified Helper (numToBool)

-- | Private Variables
cursor :: String -- Cursor display style
cursor =  ">>"

commandList :: [String]
commandList =  ["help", "setTitle","setGame"]

-- | Public Functions
activate :: IO ()
activate = do
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
                    "setGame"  -> cmdSetGame  $ unwords . extractParams $ cmd
                    _          -> error "activate -> processCommand: Something got wrong."
            else
                putStrLn "Command not found.\n"
            where
                cmdHelp :: IO ()
                cmdHelp = do
                    putStrLn "Aviable Commands: "
                    mapM_ (\x -> putStrLn $ "-" ++ x) commandList
                    putStr "\n"

                cmdSetTitle :: String -- Stream title name
                            ->  IO ()
                cmdSetTitle "" = do
                    putStrLn $ "Lütfen bir yayın başlığı giriniz!"
                    putStr "\n"
                cmdSetTitle title = do
                    putStrLn $ "Yayın başlığı \""++ title ++"\" olarak değiştirildi."
                    putStr "\n"

                cmdSetGame :: String  -- Game name
                           ->  IO ()
                cmdSetGame "" = do
                    putStrLn $ "Lütfen bir oyun ismi giriniz!"
                    putStr "\n"
                cmdSetGame game = do
                    putStrLn $ "Yayında oynanan oyun \""++ game ++"\" olarak değiştirildi."
                    putStr "\n" 

                cmd' = getCommand cmd

-- | Private Functions
isCommand     :: String -- Plain Text
              ->   Bool
isCommand text =
    Helper.numToBool . length $ filter (\x -> re_text == x) commandList
    where
        re_text = getCommand text

getCommand    :: String -- Plain Text
              -> String -- Plain Text
getCommand text
    | isHaveParams text = head . words $ text
    | otherwise         = text

isHaveParams  :: String -- Plain Text
              ->   Bool
isHaveParams text = 
    Helper.numToBool $ (length $ words $ text) - 1

extractParams ::   String -- Plain Text
              -> [String] -- Param Array
extractParams text
    | isHaveParams text = extractParams' text
    | otherwise         = []
    where
        extractParams' text = tail . words $ text
