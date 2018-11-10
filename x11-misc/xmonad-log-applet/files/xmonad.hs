import XMonad
import XMonad.Config.Gnome
import XMonad.Hooks.DynamicLog

import Control.OldException

import DBus
import DBus.Connection
import DBus.Message

main :: IO ()
main =  withConnection Session $ \dbus -> do
    getWellKnownName dbus
    xmonad $ gnomeConfig
         { logHook = dynamicLogWithPP (prettyPrinter dbus)
         }

prettyPrinter :: Connection -> PP
prettyPrinter dbus = defaultPP
    { ppOutput   = dbusOutput dbus
    , ppTitle    = pangoSanitize
    , ppCurrent  = pangoColor "green" . wrap "[" "]" . pangoSanitize
    , ppVisible  = pangoColor "yellow" . wrap "(" ")" . pangoSanitize
    , ppHidden   = const ""
    , ppUrgent   = pangoColor "red"
    , ppLayout   = const ""
    , ppSep      = " "
    }

getWellKnownName :: Connection -> IO ()
getWellKnownName dbus = tryGetName `catchDyn` (\(DBus.Error _ _) -> getWellKnownName dbus)
  where
    tryGetName = do
        namereq <- newMethodCall serviceDBus pathDBus interfaceDBus "RequestName"
        addArgs namereq [String "org.xmonad.Log", Word32 5]
        sendWithReplyAndBlock dbus namereq 0
        return ()

dbusOutput :: Connection -> String -> IO ()
dbusOutput dbus str = do
    msg <- newSignal "/org/xmonad/Log" "org.xmonad.Log" "Update"
    addArgs msg [String ("<b>" ++ str ++ "</b>")]
    -- If the send fails, ignore it.
    send dbus msg 0 `catchDyn` (\(DBus.Error _ _) -> return 0)
    return ()

pangoColor :: String -> String -> String
pangoColor fg = wrap left right
  where
    left  = "<span foreground=\"" ++ fg ++ "\">"
    right = "</span>"

pangoSanitize :: String -> String
pangoSanitize = foldr sanitize ""
  where
    sanitize '>'  xs = "&gt;" ++ xs
    sanitize '<'  xs = "&lt;" ++ xs
    sanitize '\"' xs = "&quot;" ++ xs
    sanitize '&'  xs = "&amp;" ++ xs
    sanitize x    xs = x:xs
