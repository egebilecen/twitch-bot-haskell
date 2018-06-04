module Parser (
    extractMsgInfo,
       findCommand
) where

import Types
import Text.Regex.Posix
import Data.Maybe (fromJust)
import qualified Config
import qualified Helper

-- | Public Functions
extractMsgInfo :: ServerRes -> (Nickname, ChatMsg)
extractMsgInfo res =
        (nickname, chatMsg)
    where
        nickname = res =~ "[a-zA-Z0-9_]+" :: String
        chatMsg  = last (getAllTextMatches $ res =~ "([a-zA-Z0-9ığüşöç!@#$&()\\-`.+,/\"'? -]+)" :: [String])

findCommand    :: ChatMsg   -> Maybe Command
findCommand msg =
        if ret == Nothing then
            Nothing
        else if (Helper.getFlag $ fromJust ret) == Just Special then
            case Helper.getTupleFirstElem $ fromJust ret of
                "!uptime" -> Just ("!uptime","Will be added soon.", Just Special)
        else
            ret
    where
        commandsList = Config.getCommandsInfo
        ret          = parseResult $ filter (\(a,_,_) -> a == msg) commandsList
            where
                parseResult :: [Command] -> Maybe Command
                parseResult pRes
                    | null pRes = Nothing
                    | otherwise = Just $ head pRes

-- | Private Functions
getUptime :: Int -> Int
getUptime sT =
    0
