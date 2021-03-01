#!/bin/sh
#xrandr --output DP-3 --auto --rotate normal --pos 0x0 --output eDP-1 --off && xrandr -r 144 &
xrandr --output DP-3 --primary --mode 2560x1440 -r 144 --output eDP-1 --mode 1920x1080 --left-of DP-3
feh --randomize --bg-fill ~/Pictures/wallpapers/* &
