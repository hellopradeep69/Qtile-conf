#!/bin/bash

# Apply brightness change
brightnessctl set "$1" || exit 1

# Get brightness %
level=$(brightnessctl -m | cut -d, -f4 | tr -d '%')

# Build progress bar (10 steps)
filled=$((level / 10))
empty=$((10 - filled))
bar="$(printf '█%.0s' $(seq 1 $filled))$(printf '░%.0s' $(seq 1 $empty))"

# Choose icon depending on level
if [ "$level" -le 30 ]; then
    icon="🔅"
elif [ "$level" -le 70 ]; then
    icon="🔆"
else
    icon="☀️"
fi

# Send notification (with progress bar + replace old one)
# notify-send -u low "$icon Brightness" "$level%  [$bar]" \
notify-send -u low " $icon Brightness " \
    -h int:value:"$level" -h string:synchronous:brightness
