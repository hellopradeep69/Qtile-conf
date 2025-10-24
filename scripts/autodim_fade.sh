#!/bin/bash

# === CONFIG ===
BRIGHTNESS_PATH="/sys/class/backlight/amdgpu_bl1/brightness"
IDLE_TIMEOUT=120               # Idle time in seconds before dimming
DIM_LEVEL=5                    # Minimum brightness level
FADE_STEP=1                    # Change brightness by this amount per step
FADE_DELAY=0.05                # Delay between steps (in seconds)

# === INIT ===
dimmed=false

# Get current brightness
get_brightness() {
    cat "$BRIGHTNESS_PATH"
}

# Set brightness
set_brightness() {
    echo "$1" > "$BRIGHTNESS_PATH"
}

# Fade brightness to a target value
fade_to() {
    local current=$(get_brightness)
    local target=$1

    if [[ "$current" -lt "$target" ]]; then
        # fade up
        for (( b=current; b<=target; b+=FADE_STEP )); do
            set_brightness "$b"
            sleep "$FADE_DELAY"
        done
    else
        # fade down
        for (( b=current; b>=target; b-=FADE_STEP )); do
            set_brightness "$b"
            sleep "$FADE_DELAY"
        done
    fi
}

# === LOOP ===
while true; do
    idle=$(xprintidle)
    idle_sec=$((idle / 1000))

    current_brightness=$(get_brightness)

    if [[ "$idle_sec" -ge "$IDLE_TIMEOUT" && "$dimmed" == false ]]; then
        last_brightness="$current_brightness"
        fade_to "$DIM_LEVEL"
        dimmed=true
    elif [[ "$idle_sec" -lt "$IDLE_TIMEOUT" && "$dimmed" == true ]]; then
        fade_to "$last_brightness"
        dimmed=false
    fi

    sleep 3
done
