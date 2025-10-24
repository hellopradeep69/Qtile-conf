#!/bin/bash

# Get the last hidden window node ID
last_hidden=$(bspc query -N -n .hidden | tail -n1)

# If a hidden window exists, unhide and focus it
if [ -n "$last_hidden" ]; then
    bspc node "$last_hidden" -g hidden=off
    bspc node "$last_hidden" -f
fi
