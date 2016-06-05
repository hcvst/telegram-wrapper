module Telewrap.Types where

import Control.Monad.Reader
import Control.Monad.State

import Network.HTTP.Client (Manager)
import Web.Telegram.API.Bot

data BotConfig a = BotConfig {
      tw_token :: Token
    , tw_handlers :: MessageHandlers a
    , tw_manager :: Manager
    }

data BotState a = BotState {
      tw_offset :: Maybe Int
    , tw_state :: a
    }

data BotSettings a = BotSettings {
       tw_botConfig :: BotConfig a
     , tw_botState :: BotState a
     }

data MessageHandlers a = MessageHandlers {
      tw_onMessage       :: Maybe (Message -> Bot a ())
    , tw_onInlineQuery   :: Maybe (InlineQuery -> Bot a ())
    , tw_onCallbackQuery :: Maybe (CallbackQuery -> Bot a ())
    }

type Bot a = ReaderT (BotConfig a) (StateT (BotState a) IO)