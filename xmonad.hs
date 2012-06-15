import XMonad
import XMonad.Config.Gnome
import XMonad.Hooks.DynamicLog

import XMonad.Util.Run

import XMonad.Util.EZConfig

import XMonad.Util.Scratchpad (scratchpadSpawnAction, scratchpadManageHook, scratchpadFilterOutWorkspace)
import XMonad.Util.WorkspaceCompare

-- Dzen config
myStatusBar = "dzen2 -x '0' -y '0' -h '24' -w '1280' -ta 'l' -fg '#FFFFFF' -bg '#161616'"


main = do
	dzenTopBar <- spawnPipe myStatusBar
	conf <- dzen gnomeConfig
	xmonad $ conf
		{ focusFollowsMouse = False
        , modMask = mod4Mask
        , logHook = myLogHook dzenTopBar
		} `additionalKeysP`
		[ ("M-S-q", spawn "gnome-session-quit")
		, ("M-S-l",    spawn "gnome-screensaver-command -l")
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


colorWhite   = "snow1" 
colorOrange  = "orange"        
colorRed     = "red"
colorBrown   = "#663300"     
colorZburn   = "#3f3f3f"
colorZburn1  = "#80d4aa"
colorZburn2  = "#f0dfaf"
colorRed1    = "#543532"   
colorBlack   = "#000000"         
colorGrey1   = "#808080"        
colorGrey2   = "#808080"        
colorGrey3   = "#CCCCCC"
