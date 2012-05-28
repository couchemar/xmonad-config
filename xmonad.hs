import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Config.Gnome

import XMonad.Layout
import XMonad.Layout.Spiral
 
main = do
    xmonad $ gnomeConfig
        { modMask = mod4Mask
        , terminal = "urxvt"
        ,  manageHook = manageDocks <+> manageHook gnomeConfig
        , layoutHook = avoidStruts  $  layoutHook gnomeConfig
        , logHook = logHook gnomeConfig
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
        ]
