{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BangPatterns #-}

module Telewrap.Bot (newBot, runBot) where

import Control.Concurrent (threadDelay)
import Control.Monad (forever)
import Control.Monad.Reader
import Control.Monad.State
import qualified Data.Text as T
import Data.Monoid ((<>))
import Network.HTTP.Client (Manager, newManager)
import Network.HTTP.Client.TLS (tlsManagerSettings)
import Servant.Client (ServantError)
import System.IO (stderr, hPutStrLn)

import Web.Telegram.API.Bot

import Telewrap.Types


import Data.Maybe

newBot :: T.Text -> MessageHandlers a -> a -> IO (BotSettings a)
newBot tokenString handlers clientState = do
    let token = Token $ "bot" <> tokenString
    manager <- newManager tlsManagerSettings
    return $ BotSettings (BotConfig token handlers manager) (BotState Nothing clientState)

runBot :: BotSettings a -> IO ((), BotState a)
runBot botSettings = runStateT (runReaderT poll (tw_botConfig botSettings)) (tw_botState botSettings)

poll :: Bot a ()
poll = forever $ do
    liftIO $ threadDelay 300000 -- 300 ms
    either onError processUpdatesResponse =<< getTelegramUpdates
  where
    onError err = liftIO $ hPutStrLn stderr $ "getUpdates failed: " ++ show err

getTelegramUpdates :: Bot a (Either ServantError UpdatesResponse)
getTelegramUpdates = do
    config <- ask
    state <- get
    liftIO $ getUpdates (tw_token config) (tw_offset state) Nothing (Just 10) (tw_manager config)

processUpdatesResponse :: UpdatesResponse -> Bot a ()
processUpdatesResponse UpdatesResponse {update_result = updates} = mapM_ processUpdate updates

processUpdate :: Update -> Bot a ()
processUpdate update = do
    BotConfig {tw_handlers = MessageHandlers {
          tw_onMessage = onMg
        , tw_onInlineQuery = onIQ
        , tw_onCallbackQuery = onCQ
        }
    } <- ask

    maybe (return ()) id $ onMg <*> (message update)
    maybe (return ()) id $ onIQ <*> (inline_query update)
    maybe (return ()) id $ onCQ <*> (callback_query update)

    state <- get
    put $ state {tw_offset = (Just $ (update_id update) + 1)}
