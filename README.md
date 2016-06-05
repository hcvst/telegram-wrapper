Telewrap
========

*Telewrap* is a layer on top of the [Haskell Telegram API](https://github.com/klappvisor/haskell-telegram-api)
that let's you focus on writing Telegram bots.

Let's look at a Hello World example.

```haskell
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
```

The `MessageHandlers` type is defined in `Telewrap.Types` and allows you to specify
handlers for Telegram's `Message`, `InlineQuery` and `CallbackQuery` types. 
The Hello World bot example above only registers a handler for ordinary text messages.

As you can see from the type signature of `main`, *Telewrap* is stateful but
the simple Hello World example is stateless and passes void `()` as the 
third argument to `newBot` which reflects as `BotState ()` in the signature.

*Telewrap* exposes two `Telewrap.Helpers` `getState` and `putState` to access and
update your state respectively.

Types such as `Message` are re-exported by *Telewrap* from `Web.Telegram.API.Bot`
so you are free to import and use any of the functionality `Web.Telegram.API.Bot`
provides.

The development of *Telewrap* has only just started. If you find that
you need to access `Web.Telegram.API.Bot` a lot - and you will at this early stage - 
please consider improving `Telewrap.Helpers` or `Telewrap.Messaging` and send 
me a pull request.

A big Thank You to [klappvisor](https://github.com/klappvisor), the author of 
the [Haskell Telegram API](https://github.com/klappvisor/haskell-telegram-api).