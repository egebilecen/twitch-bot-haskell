module Helper (
      getTupleFirstElem,
     getTupleSecondElem,
      getTupleThirdElem,
     applyFlagToMessage
) where

import Types

-- | Public Functions
getTupleFirstElem  :: Command -> String
getTupleFirstElem (a, _, _)  = a

getTupleSecondElem :: Command -> String
getTupleSecondElem (_, b, _) = b

getTupleThirdElem  :: Command -> Maybe CommandFlag
getTupleThirdElem (_, _, c)  = c

applyFlagToMessage :: Maybe CommandFlag -> String -> ChatMsg
applyFlagToMessage flag res
    | flag == Nothing      = res
    | flag == Just Reply   = "@" ++ res ++ ", "
