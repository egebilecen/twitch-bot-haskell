module Helper (
      getTupleFirstElem,
     getTupleSecondElem,
      getTupleThirdElem,
     applyFlagToMessage,
                getFlag
) where

import Types

-- | Public Functions
getTupleFirstElem  :: Command 
                   ->  String
getTupleFirstElem (a, _, _)  = a

getTupleSecondElem :: Command 
                   ->  String
getTupleSecondElem (_, b, _) = b

getTupleThirdElem  ::           Command 
                   -> Maybe CommandFlag
getTupleThirdElem (_, _, c)  = c

getFlag            ::           Command 
                   -> Maybe CommandFlag
getFlag (_,_,f) = f

applyFlagToMessage :: Maybe CommandFlag
                   ->          Nickname 
                   ->           ChatMsg 
                   ->           ChatMsg
applyFlagToMessage flag nickname msg
    | flag == Just ReplyStart   = "@" ++ nickname ++ " - " ++ msg
    | flag == Just ReplyEnd     = msg ++ " - @" ++ nickname
    | otherwise                 = msg


-- | Private Functions
getUptime :: Int -> Int
getUptime sT =
    0
