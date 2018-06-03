module Bot (
        doLogin,
    writeToChat,
      handleRes,
    joinChannel
) where

import System.IO
import Data.List
import Text.Regex.Posix
import Data.Maybe (fromJust)

-- | Custom imports
import Types
import qualified Parser

-- | Public Functions
handleRes   :: Handle       -> ServerRes   -> Channel     -> IO ()
handleRes hdl res channel = do
    if "PING" `isInfixOf` res then
        sendPong hdl "tmi.twitch.tv"
    else if "PRIVMSG" `isInfixOf` res then
        if commandRes /= Nothing then
            writeToChat hdl channel $ fromJust $ fmap snd commandRes
        else
            return ()
    else
        return ()

    where
        (nickname, chatMsg) = Parser.extractMsgInfo res
        commandRes          = Parser.findCommand chatMsg

doLogin     :: Handle       -> BotUsername -> BotOAuth     -> IO ()
doLogin hdl nickname oauth = do
    writeToSystem hdl $ "PASS " ++    oauth
    writeToSystem hdl $ "NICK " ++ nickname

writeToChat :: Handle       -> Channel     -> ChatMsg      -> IO ()
writeToChat hdl channel msg = do
    writeToSystem hdl $ "PRIVMSG #"++ channel ++ " :" ++ msg

joinChannel   :: Handle     -> Channel     -> IO ()
joinChannel hdl channel = do
    writeToSystem hdl $ "JOIN #" ++ channel
    writeToChat   hdl channel $ initText
    where
        initText = "Eveet. Vücuduma gelen elektiriği hissedebiliyorum. Sahneye çıkma vaktim gelmiş olmalı. (Bot Aktif)"

-- | Private Functions
writeToSystem :: Handle     -> String      -> IO ()
writeToSystem hdl cmd = do
    hPutStrLn hdl cmd

sendPong      :: Handle     -> ResAddr     -> IO ()
sendPong hdl addr = 
    writeToSystem hdl $ "PONG :" ++ addr
