import XMonad
import XMonad.Config.Gnome

main = do
	xmonad $ gnomeConfig
		{ focusFollowsMouse = False
        , modMask = mod4Mask
		}
