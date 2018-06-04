module Helper (
     getTupleFirstElem,
    getTupleSecondElem,
     getTupleThirdElem
) where

import Types

getTupleFirstElem  :: Command -> String
getTupleFirstElem (a, _, _)  = a

getTupleSecondElem :: Command -> String
getTupleSecondElem (_, b, _) = b

getTupleThirdElem  ::  Command -> Maybe [CommandFlag]
getTupleThirdElem (_, _, c)  = c
