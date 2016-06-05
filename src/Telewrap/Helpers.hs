module Telewrap.Helpers where

import Control.Monad.State
import qualified Data.Text as T

import Web.Telegram.API.Bot

import Telewrap.Types

getChatIdFromMessage :: Message -> T.Text
getChatIdFromMessage = T.pack.show.chat_id.chat

getState :: Bot a (a)
getState = do
    state <- get
    return $ tw_state state

putState :: a -> Bot a ()
putState clientState = do
    state <- get
    put $ state {tw_state = clientState}

getCommand = undefined
