module Bot (
        doLogin,
    writeToChat,
      handleRes,
    joinChannel,
    exitChannel
) where

import System.IO
import Data.List
import Text.Regex.Posix
import Data.Maybe (fromJust)

import Types
import qualified Parser
import qualified Helper

-- | Public Functions
handleRes   ::    Handle       
            -> ServerRes   
            ->   Channel     
            ->     IO ()
handleRes hdl res channel = do
    -- handle ping request
    if "PING" `isInfixOf` res then
        sendPong hdl "tmi.twitch.tv"
    -- handle message request from channel
    else if "PRIVMSG" `isInfixOf` res then
        if commandRes /= Nothing then
            -- | There is special command
            writeToChat hdl channel $ Helper.applyFlagToMessage commandFlag nickname (Helper.getTupleSecondElem $ fromJust commandRes)
        else
            -- | An ordinary message
            return ()
    -- | Unnecessary request
    else
        return ()

    where
        (nickname, chatMsg) = Parser.extractMsgInfo res
        commandRes          = Parser.findCommand chatMsg
        commandFlag         = Helper.getTupleThirdElem $ fromJust commandRes

doLogin     ::      Handle       
            -> BotUsername
            ->    BotOAuth     
            ->       IO ()
doLogin hdl nickname oauth = do
    writeToSystem hdl $ "PASS " ++    oauth
    writeToSystem hdl $ "NICK " ++ nickname

writeToChat ::  Handle       
            -> Channel     
            -> ChatMsg      
            ->   IO ()
writeToChat hdl channel msg = do
    writeToSystem hdl $ "PRIVMSG #"++ channel ++ " :" ++ msg

joinChannel ::  Handle       
            -> Channel     
            ->   IO ()
joinChannel hdl channel = do
    writeToSystem hdl $ "JOIN #" ++ channel
    writeToChat   hdl channel $ initText
    where
        initText = "Eveet. Vücuduma gelen elektiriği hissedebiliyorum. Sahneye çıkma vaktim gelmiş olmalı. (Bot Aktif)"

exitChannel ::  Handle
            -> Channel
            ->   IO ()
exitChannel hdl channel = do
    writeToSystem hdl $ "PART " ++ channel 

-- | Private Functions
writeToSystem :: Handle     
              -> String      
              ->  IO ()
writeToSystem hdl cmd = do
    hPutStrLn hdl cmd

sendPong      ::  Handle     
              -> ResAddr  
              ->   IO ()
sendPong hdl addr = 
    writeToSystem hdl $ "PONG :" ++ addr
