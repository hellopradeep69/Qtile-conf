#!/bin/bash

# Set wallpaper and generate colors using pywal
wal -i ~/Pictures/cyper2.jpg

# Wait for wal to finish generating colors
sleep 1

# Relaunch polybar (with --shapes argument if your script supports it)
#~/.config/polybar/launch.sh --shapes
# Kill existing polybar
killall -q polybar

# Wait until it's completely shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.2; done

# Launch bar
~/.config/polybar/launch.sh --hack
