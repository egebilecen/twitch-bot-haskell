module Parser (
    extractMsgInfo,
       findCommand
) where

import Types
import Text.Regex.Posix
import qualified Config

-- | Public Functions
extractMsgInfo :: ServerRes -> (Nickname, ChatMsg)
extractMsgInfo res =
        (nickname, chatMsg)
    where
        nickname = res =~ "[a-zA-Z0-9_]+" :: String
        chatMsg  = last (getAllTextMatches $ res =~ "([a-zA-Z0-9ığüşöç!@#$&()\\-`.+,/\"'? -]+)" :: [String])

findCommand    :: ChatMsg   -> Maybe Command
findCommand msg =
        ret
    where
        commandsList = Config.getCommandsInfo
        ret = parseResult $ filter (\(a,_,_) -> a == msg) commandsList
            where
                parseResult :: [Command] -> Maybe Command
                parseResult pRes
                    | null pRes = Nothing
                    | otherwise = Just $ head pRes
