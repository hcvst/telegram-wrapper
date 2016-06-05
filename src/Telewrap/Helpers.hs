module Telewrap.Helpers where

import qualified Data.Text as T

import Web.Telegram.API.Bot

getChatIdFromMessage :: Message -> T.Text
getChatIdFromMessage = T.pack.show.chat_id.chat

getCommand = undefined
