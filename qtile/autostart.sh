#!/usr/bin/env bash

# Clipboard manager
wl-paste --watch cliphist store &

#copyq to have clipboard
copyq &

# Notification daemon
dunst &

# Start compositor
picom &

# feh --bg-scale ~/Pictures/Wallpapers/skeletonparty.jpg &

# Custom scripts
~/.local/bin/keybind.sh &
~/.local/bin/battery-notify2.sh &

# polybar
# $HOME/.config/polybar/launch.sh &

# Open the apps
# zen &
# wezterm start --always-new-process &
