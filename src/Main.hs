{-# LANGUAGE OverloadedStrings #-}

module Main where

import Telewrap

main :: IO ((), BotState ())
main = runBot =<< newBot token handlers ()
  where
    token = "131224483:AAHkuSrad7c_Bmb8-vxSsI5HnmDiJTn7K1c"
    handlers = MessageHandlers (Just onMessage) Nothing Nothing

onMessage :: Message -> Bot ()()
onMessage = sendMessageResponse "Hello World"