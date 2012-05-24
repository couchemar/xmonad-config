#!/bin/sh

setxkbmap -layout "us,ru" -option "" -option "grp:caps_toggle"

trayer --edge top --align right --SetDockType true --SetPartialStrut true \
 --expand true --width 10 --transparent true --tint 0x191970 --height 12 &

xscreensaver &
