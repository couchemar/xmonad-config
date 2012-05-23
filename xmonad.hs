import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Config.Gnome
 
main = do
    xmonad =<< dzen gnomeConfig
        { modMask = mod4Mask
        , terminal = "urxvt"
        }
