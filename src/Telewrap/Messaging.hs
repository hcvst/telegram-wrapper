module Telewrap.Messaging where

import Control.Monad.Reader
import qualified Data.Text as T

import Web.Telegram.API.Bot

import Telewrap.Types
import Telewrap.Helpers

sendMessageResponse :: T.Text -> Message -> Bot a ()
sendMessageResponse text msg = do
    let request = sendMessageRequest (getChatIdFromMessage msg) text
    config <- ask
    liftIO $ sendMessage (tw_token config) request (tw_manager config)
    return ()