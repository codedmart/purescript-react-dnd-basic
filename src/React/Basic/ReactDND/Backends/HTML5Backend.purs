module React.Basic.ReactDND.Backends.HTML5Backend where

import Data.Nullable (Nullable)
import React.Basic.ReactDND (Backend)
import React.Basic.Hooks (Ref)
import Web.DOM (Node)

foreign import html5Backend :: Backend

foreign import getEmptyImage :: Ref (Nullable Node)
