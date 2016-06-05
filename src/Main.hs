{-# LANGUAGE OverloadedStrings #-}

module Main where

import Telewrap

main :: IO ((), BotState ())
main = runBot =<< newBot token handlers ()
  where
    token = "131224483:AAE9t3N83-1FwWhnx4eay80I0HI1a65tqqI"
    handlers = MessageHandlers (Just onMessage) Nothing Nothing

onMessage :: Message -> Bot ()()
onMessage = sendMessageResponse "Hello World"