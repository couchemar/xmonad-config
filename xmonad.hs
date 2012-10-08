import XMonad
import XMonad.Config.Gnome

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks

import XMonad.Util.Run

import XMonad.Util.EZConfig

import XMonad.Util.Scratchpad (scratchpadFilterOutWorkspace)

import XMonad.Util.WorkspaceCompare

import XMonad.Layout.Spiral
import XMonad.Layout.Cross

import XMonad.Layout.MosaicAlt
import qualified Data.Map as M


-- Dzen config
myStatusBar = "dzen2 -x '0' -y '744' -h '24' -w '1366' -ta 'l' -fg '#FFFFFF' -bg '#161616'"

myWorkspaces = ["1-im", "2-web"] ++ map show [3..9]

main = do
    dzenTopBar <- spawnPipe myStatusBar
    conf <- dzen gnomeConfig
    xmonad $ conf
        { focusFollowsMouse = False
        , workspaces = myWorkspaces
        , modMask = mod4Mask
        , logHook = myLogHook dzenTopBar
        , layoutHook = myLayoutHook
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


myLayoutHook = avoidStruts  $  layoutHook gnomeConfig
                ||| spiral (6/7) ||| simpleCross
                ||| MosaicAlt M.empty
