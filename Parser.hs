module Parser (
    extractMsgInfo
) where

import Types
import Text.Regex.Posix

-- | Public Functions [a-zA-Z]+
extractMsgInfo :: ServerRes -> (Nickname, ChatMsg)
extractMsgInfo res =
        (nickname, chatMsg)
    where
        nickname =        res =~ "[a-zA-Z0-9_]+" ::   String
        chatMsg  = last (getAllTextMatches $ res =~ "([a-zA-Z0-9ığüşöç!@#$&()\\-`.+,/\"'? -]+)" :: [String])
