{-# LANGUAGE OverloadedStrings #-}

module Telewrap.Bot (setupBot, run) where

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

setupBot :: T.Text -> MessageHandlers a -> a -> IO (BotSettings a)
setupBot tokenString handlers clientState = do
    let token = Token $ "bot" <> tokenString
    manager <- newManager tlsManagerSettings
    return $ BotSettings (BotConfig token handlers manager) (BotState Nothing clientState)

run :: BotSettings a -> IO ((), BotState a)
run botSettings = runStateT (runReaderT poll (botConfig botSettings)) (botState botSettings)

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
    liftIO $ getUpdates (token config) (offset state) Nothing (Just 10) (manager config)

processUpdatesResponse :: UpdatesResponse -> Bot a ()
processUpdatesResponse UpdatesResponse {update_result = updates} = mapM_ processUpdate updates

processUpdate :: Update -> Bot a ()
processUpdate update = do
    BotConfig {handlers = MessageHandlers {
          onMessage = onMg
        , onInlineQuery = onIQ
        , onCallbackQuery = onCQ
        }
    } <- ask

    case update of
        Update {message=mg}        -> return (onMg <*> mg)
        Update {inline_query=iq}   -> return (onIQ <*> iq)
        Update {callback_query=cq} -> return (onCQ <*> cq)

    state <- get
    put $ state {offset = (Just $ update_id update)}
