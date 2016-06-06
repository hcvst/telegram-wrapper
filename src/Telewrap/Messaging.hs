module Telewrap.Messaging where

import Control.Monad.Reader
import qualified Data.Text as T


import Network.HTTP.Client (Manager)
import Servant.Client (ServantError)
import Web.Telegram.API.Bot

import Telewrap.Types
import Telewrap.Helpers

type API a b = Token -> a -> Manager -> IO (Either ServantError b)

bot :: API a b -> a -> Bot c (Either ServantError b)
bot apiFunction argument = do
    config <- ask
    liftIO $ apiFunction (tw_token config) argument (tw_manager config)

sendMessageResponse :: T.Text -> Message -> Bot a ()
sendMessageResponse text msg = do
    let request = sendMessageRequest (getChatIdFromMessage msg) text
    bot sendMessage request
    return ()


