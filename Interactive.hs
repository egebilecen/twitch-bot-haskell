module Interactive (
    activate
) where

import Types
import Control.Monad (forever)
import System.Exit   (exitSuccess)
import System.IO     (Handle)

import qualified Helper (numToBool)
import qualified Bot
import qualified API

-- | Private Variables
cursor :: String -- Cursor display style
cursor =  ">>"

commandList :: [String]
commandList =  ["help", "setTitle","setGame", "exit"]

-- | Public Functions
activate ::  Handle
         -> Channel
         ->   IO ()
activate hdl channel = do
    putStrLn "[?] Interactive mode activated. Type \"help\" for command list.\n"

    forever $ do
        putStr cursor
        command <- getLine
        
        processCommand hdl channel command
    where
        processCommand ::  Handle
                       -> Channel
                       ->  String
                       ->   IO ()
        processCommand hdl channel cmd = do
            if isCommand cmd then
                case cmd' of
                    "help"     -> cmdHelp
                    "setTitle" -> cmdSetTitle $ unwords . extractParams $ cmd
                    "setGame"  -> cmdSetGame  $ unwords . extractParams $ cmd
                    "exit"     -> cmdExit hdl channel
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
                
                cmdExit ::  Handle 
                        -> Channel
                        ->   IO ()
                cmdExit hdl channel = do
                    Bot.writeToChat hdl channel "Hayıır. Vücudumda akan elektirik azalmaya başladı. Sahneden inme vaktim gelmiş olmalı. (Bot Pasif)"
                    Bot.exitChannel hdl channel 
                    exitSuccess

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
