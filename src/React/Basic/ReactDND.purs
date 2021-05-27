module React.Basic.ReactDND
  ( Backend
  , DNDContext
  , dndProvider
  , useDragLayer
  , UseDragLayer
  , useDrag
  , UseDrag
  , useDrop
  , UseDrop
  , mergeTargets
  ) where

import Prelude
import Data.Maybe (Maybe)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, runEffectFn1)
import React.Basic.Hooks (Hook, JSX, ReactComponent, Ref, element, unsafeHook)
import Web.DOM (Node)

foreign import data Backend :: Type

foreign import data DNDContext :: Type

dndProvider :: Backend -> JSX -> JSX
dndProvider backend children = element dndProvider_ { backend, children }

useDragLayer ::
  forall props.
  Hook UseDragLayer
    { info :: Maybe
      { item :: { id :: String | props }
      , itemType :: String
      , currentOffset :: { x :: Number, y :: Number }
      , clientOffset :: { x :: Number, y :: Number }
      , initialOffset :: { x :: Number, y :: Number }
      }
    , isDragging :: Boolean
    }
useDragLayer =
  unsafeHook do
    { info, isDragging } <-
      runEffectFn1 useDragLayer_ unit
    pure
      { info: Nullable.toMaybe info
      , isDragging
      }

foreign import data UseDragLayer :: Type -> Type

useDrag ::
  forall props.
  { type :: String
  , item :: { id :: String | props }
  , begin :: Maybe { id :: String | props } -> Effect Unit
  , end :: Maybe { id :: String | props } -> Effect Unit
  } ->
  Hook UseDrag
    { isDragging :: Boolean
    , connectDrag :: Ref (Nullable Node)
    , preview :: EffectFn2 (Ref (Nullable Node)) ({ captureDraggingState :: Boolean }) Unit
    }
useDrag { type: type_, item, begin, end } =
  unsafeHook do
    runEffectFn1 useDrag_
      { type: type_
      , item
      , begin: begin <<< Nullable.toMaybe
      , collect: Nullable.null
      , end: end <<< Nullable.toMaybe
      }

foreign import data UseDrag :: Type -> Type

useDrop ::
  forall props.
  { accept :: String
  , onDrop :: Maybe { id :: String | props } -> Effect Unit
  } ->
  Hook UseDrop
    { item :: Maybe { id :: String | props }
    , isOver :: Boolean
    , connectDrop :: Ref (Nullable Node)
    }
useDrop { accept, onDrop } =
  unsafeHook do
    { item, isOver, connectDrop } <-
      runEffectFn1 useDrop_
        { accept
        , onDrop: onDrop <<< Nullable.toMaybe
        }
    pure { item: Nullable.toMaybe item, isOver, connectDrop }

foreign import data UseDrop :: Type -> Type

foreign import dndProvider_ :: ReactComponent { backend :: Backend, children :: JSX }

foreign import useDragLayer_ ::
  forall props.
  EffectFn1
    Unit
    { info :: Nullable
      { item :: { id :: String | props }
      , itemType :: String
      , currentOffset :: { x :: Number, y :: Number }
      , clientOffset :: { x :: Number, y :: Number }
      , initialOffset :: { x :: Number, y :: Number }
      }
    , isDragging :: Boolean
    }

foreign import useDrag_ ::
  forall props props_.
  EffectFn1
    { type :: String
    , item :: { id :: String | props }
    , begin :: Nullable { id :: String | props } -> Effect Unit
    , collect :: Nullable (Unit -> props_)
    , end :: Nullable { id :: String | props } -> Effect Unit
    }
    { isDragging :: Boolean
    , connectDrag :: Ref (Nullable Node)
    , preview :: EffectFn2 (Ref (Nullable Node)) ({ captureDraggingState :: Boolean }) Unit
    }

foreign import useDrop_ ::
  forall props.
  EffectFn1
    { accept :: String
    , onDrop :: Nullable { id :: String | props } -> Effect Unit
    }
    { item :: Nullable { id :: String | props }
    , isOver :: Boolean
    , connectDrop :: Ref (Nullable Node)
    }

foreign import mergeTargets :: Ref (Nullable Node) -> Ref (Nullable Node) -> Ref (Nullable Node)
