{-# LANGUAGE OverloadedStrings #-}

module Main where


import Control.Monad.Reader
import Control.Monad.State

import qualified Data.Text as T

import Telewrap

main :: IO ((), BotState (Maybe a))
main = runBot =<< newBot token handlers Nothing
  where
    token = "131224483:AAE9t3N83-1FwWhnx4eay80I0HI1a65tqqI"
    handlers = MessageHandlers (Just onMessage) Nothing Nothing

onMessage :: Message -> Bot (Maybe a) ()
onMessage msg = sendMessageResponse msg "Hello World"