#!/bin/bash

WALLPAPERS="$HOME/Pictures/Wallpapers"

# Build list of wallpapers with clean names
# Example: "space.jpg" -> "Space Theme"
WALL_LIST=$(find "$WALLPAPERS" -type f | while read -r file; do
    # Extract base name, remove extension
    name=$(basename "$file" | sed -E 's/\.[^.]+$//')
    # Replace _ or - with space
    name=$(echo "$name" | sed -E 's/[_-]/ /g')
    # Remove common words like "wallpaper" or "bg"
    name=$(echo "$name" | sed -E 's/\b(wallpaper|bg)\b//ig')
    # Capitalize first letter and append "Theme"
    name="$(tr '[:lower:]' '[:upper:]' <<<${name:0:1})${name:1} Theme"
    # Remove extra spaces
    name=$(echo "$name" | xargs)
    echo "$name|$file"
done)

# Show pretty names in rofi
SELECTED=$(echo "$WALL_LIST" | cut -d'|' -f1 |
    rofi -dmenu -i -p "🎨 Pick Wallpaper" \
        -theme-str 'window {width: 40%;}' 2>/dev/null)

# Exit if nothing chosen
[ -z "$SELECTED" ] && exit

# Map selected name back to real file
FILE=$(echo "$WALL_LIST" | grep "^$SELECTED|" | cut -d'|' -f2)

# Apply wallpaper silently (suppress Xlib warnings)
feh --bg-scale "$FILE" 2>/dev/null

# Generate pywal colors (optional)
# wal -i "$FILE" -q 2>/dev/null

# Relaunch polybar with "shades"
~/.config/polybar/launch.sh --shades 2>/dev/null
# ~/.config/polybar/launch.sh --pwidgets 2>/dev/null

# Run polybar pywal integration script
# /home/hellopradeep/.config/polybar/pwidgets/scripts/pywal.sh "$FILE" 2>/dev/null
/home/hellopradeep/.config/polybar/shades/scripts/pywal.sh "$FILE" 2>/dev/null
