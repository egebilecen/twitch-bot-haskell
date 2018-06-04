module Helper (
      getTupleFirstElem,
     getTupleSecondElem,
      getTupleThirdElem,
     applyFlagToMessage,
                getFlag
) where

import Types

-- | Public Functions
getTupleFirstElem  :: Command -> String
getTupleFirstElem (a, _, _)  = a

getTupleSecondElem :: Command -> String
getTupleSecondElem (_, b, _) = b

getTupleThirdElem  :: Command -> Maybe CommandFlag
getTupleThirdElem (_, _, c)  = c

getFlag            :: Command -> Maybe CommandFlag
getFlag (_,_,f) = f

applyFlagToMessage :: Maybe CommandFlag -> String -> ChatMsg
applyFlagToMessage flag res
    | flag == Just ReplyStart   = "@" ++ res ++ ", "
    | otherwise                 = ""
