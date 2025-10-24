#!/bin/bash

# -------------------------
# Define your sound files
# -------------------------
# Workspace switch
SOUND_DESKTOP="/home/hellopradeep/Sounds/Cyberpunk/OpeningPhoneContacts.mp3"

# New window opens
SOUND_NEW="/home/hellopradeep/Sounds/Cyberpunk/open.mp3"

# Window closes
SOUND_CLOSE="/home/hellopradeep/Sounds/Cyberpunk/close.mp3"

# Window focus
# SOUND_FOCUS="/home/hellopradeep/Sounds/Cyberpunk/tick.mp3" uncomment

# Window swap
SOUND_SWAP="/home/hellopradeep/Sounds/Cyberpunk/change.mp3"

# -------------------------
# Listen for desktop focus (workspace switch)
# -------------------------
bspc subscribe desktop_focus | while read -r _; do
    paplay "$SOUND_DESKTOP" &
done & # Run in background

# -------------------------
# Listen for window events (new/close)
# -------------------------
bspc subscribe node_add node_remove | while read -r event _; do
    case "$event" in
    node_add) paplay "$SOUND_NEW" & ;;
    node_remove) paplay "$SOUND_CLOSE" & ;;
    esac
done &

# -------------------------
# switch window to workspace  (switching between windows)
# -------------------------
#
bspc subscribe node_transfer | while read -r _; do
    paplay "$SOUND_SWAP" &
done &

# -------------------------
# Listen for window focus (switching between windows) uncomment
# -------------------------
# bspc subscribe node_focus | while read -r wid; do
#     # Count windows in the current desktop
#     count=$(bspc query -N -d focused | wc -l)
#
#     # Play focus sound only if more than 1 window exists
#     if [ "$count" -gt 1 ]; then
#         paplay "$SOUND_FOCUS" &
#     fi
# done &
