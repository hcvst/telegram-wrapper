Telewrap
========

**Telewrap** is a layer on top of the [Haskell Telegram API](https://github.com/klappvisor/haskell-telegram-api)
that let's you focus on writing Telegram bots.

Let's look at a Hello World example.

```
{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Data.Text as T

import Telewrap

main :: IO ((), BotState ())
main = runBot =<< newBot token handlers ()
  where
    token = "131224483:AAE9t3N83-1FwWhnx4eay80I0HI1a65tqqI"
    handlers = MessageHandlers (Just onMessage) Nothing Nothing

onMessage :: Message -> Bot ()()
onMessage = sendMessageResponse "Hello World"
```

As you can see from the type signature of `main` **Telewrap** is stateful but
the Hello World example is not, since void `()` is passed as the third argument to
`newBot`.

Types such as `Message` are rexported by **Telewrap** from `Web.Telegram.API.Bot`
so you are free to import and use any of the functionality `Web.Telegram.API.Bot`
provides.

The development of **Telewrap** has only just started. If you find that
you need to access `Web.Telegram.API.Bot` a lot - and you likely will - please 
consider adding a helper to `Telewrap.Helpers` or `Telewrap.Messaging`.

A big Thank You to [klappvisor](https://github.com/klappvisor), the author of 
the [Haskell Telegram API](https://github.com/klappvisor/haskell-telegram-api).