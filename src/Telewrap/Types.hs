module Telewrap.Types where

import Control.Monad.Reader
import Control.Monad.State

import Network.HTTP.Client (Manager)
import Web.Telegram.API.Bot

data BotConfig a = BotConfig {
      token :: Token
    , handlers :: MessageHandlers a
    , manager :: Manager
    }

data BotState a = BotState {
      offset :: Maybe Int
    , state :: a
    }

data BotSettings a = BotSettings {
      botConfig :: BotConfig a
     , botState :: BotState a
     }

data MessageHandlers a = MessageHandlers {
      onMessage       :: Maybe (Message -> Bot a ())
    , onInlineQuery   :: Maybe (InlineQuery -> Bot a ())
    , onCallbackQuery :: Maybe (CallbackQuery -> Bot a ())
    }

type Bot a = ReaderT (BotConfig a) (StateT (BotState a) IO)