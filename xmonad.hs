import XMonad
import XMonad.Config.Kde

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks

import XMonad.Util.Run

import XMonad.Util.EZConfig

import XMonad.Util.Scratchpad ( scratchpadFilterOutWorkspace
                                                     , scratchpadManageHookDefault )

import XMonad.Util.WorkspaceCompare

import XMonad.Layout.Spiral
import XMonad.Layout.Cross

import XMonad.Layout.MosaicAlt
import qualified Data.Map as M


-- Dzen config
myStatusBar = "dzen2 -x '0' -y '0' -h '22' -w '1920' -ta 'l' -fg '#FFFFFF' -bg '#161616'"

myWorkspaces = ["1-im", "2-web"] ++ map show [3..9]

myTerminal = "konsole"

main = do
    dzenTopBar <- spawnPipe myStatusBar
    conf <- dzen kde4Config
    xmonad $ conf
        { terminal = myTerminal
        , focusFollowsMouse = False
        , workspaces = myWorkspaces
        , modMask = mod4Mask
        , logHook = myLogHook dzenTopBar
        , layoutHook = myLayoutHook
        , manageHook = myManageHook
        } `additionalKeysP`
        [ ("M-S-q", spawn "gnome-session-quit")
        , ("M-S-l",    spawn "gnome-screensaver-command -l")
        , ("M-r", spawn "dmenu_run")
        ]

myLogHook h = (dynamicLogWithPP $ defaultPP {
    ppSort = fmap (.scratchpadFilterOutWorkspace) getSortByTag
  , ppCurrent         = dzenColor colorZburn1 colorZburn . pad
  , ppHidden          = dzenFG    colorZburn2 . pad
  , ppHiddenNoWindows = namedOnly
  , ppUrgent          = myWrap    colorRed   "{"  "}"  . pad
  , ppTitle           = dzenColor colorZburn2 colorZburn . shorten 55
  , ppWsSep           = " "
  , ppSep             = " | "
  , ppOutput          = hPutStrLn h
 })

  where

    dzenFG c     = dzenColor c ""
    myWrap c l r = wrap (dzenFG c l) (dzenFG c r)
    namedOnly ws = if any (`elem` ws) ['a'..'z'] then pad ws else ""


colorRed     = "red"
colorZburn   = "#3f3f3f"
colorZburn1  = "#80d4aa"
colorZburn2  = "#f0dfaf"


myLayoutHook = avoidStruts  $  layoutHook kde4Config
                ||| spiral (6/7) ||| simpleCross
                ||| MosaicAlt M.empty


myManageHook = scratchpadManageHookDefault <+>composeAll (
             [ manageHook kde4Config
             , className =? "Tilda" --> doFloat
             , className =? "Guake.py" --> doFloat
             , className =? "Yakuake" --> doFloat
             , className =? "Unity-2d-panel" --> doIgnore
             , className =? "Unity-2d-shell" --> doIgnore
             , className =? "Unity-2d-launcher" --> doIgnore
             , resource =? "desktop_window" --> doIgnore
             , resource =? "kdesktop" --> doIgnore
             , className =? "MPlayer" --> doFloat
             , className =? "Plasma" --> doFloat
             , className =? "Plasma-desktop" --> doFloat
             , className =? "Knotes" --> doFloat
             , className =? "Klipper" --> doFloat
             , className =? "XCalc" --> doFloat
             , className =? "Kcalc" --> doFloat
             , className =? "emulator-arm" --> doFloat
             ])
