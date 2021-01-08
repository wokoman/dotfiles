#!/bin/sh
xrandr --output DP-3 --auto --rotate normal --pos 0x0 --output eDP-1 --off && xrandr -r 144 &
feh --randomize --bg-fill ~/Pictures/wallpapers/* &
