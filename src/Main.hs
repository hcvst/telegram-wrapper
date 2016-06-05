{-# LANGUAGE OverloadedStrings #-}

module Main where


import Control.Monad.Reader
import Control.Monad.State

import qualified Data.Text as T

import Telewrap.Types
import Telewrap.Bot
import Web.Telegram.API.Bot

main :: IO ((), BotState (Maybe a))
main = runBot =<< newBot token handlers Nothing
  where
    token = "131224483:AAE9t3N83-1FwWhnx4eay80I0HI1a65tqqI"
    handlers = MessageHandlers (Just onMessage) Nothing Nothing

onMessage :: Message -> Bot (Maybe a) ()
onMessage msg = do

    liftIO $ putStrLn "onMessage called"
    let request = (sendMessageRequest (T.pack.show.chat_id.chat $ msg) "Hi")
    config <- ask
    liftIO $ sendMessage (tw_token config) request (tw_manager config)
    return ()