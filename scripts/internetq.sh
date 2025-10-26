#!/bin/bash

# -----------------------------
# Config
# -----------------------------
ROFI_THEME="$HOME/.config/rofi/themes/spot.rasi"
ROFI_OPTS="-theme $ROFI_THEME -matching fuzzy -i"

# -----------------------------
# Workspace mapping
# -----------------------------
declare -A ws_map=(
    ["one"]=1 ["two"]=2 ["three"]=3 ["four"]=4 ["five"]=5
    ["six"]=6 ["seven"]=7 ["eight"]=8 ["nine"]=9 ["zero"]=0
)

# -----------------------------
# Prompt for input
# -----------------------------
input=$(rofi -dmenu $ROFI_OPTS -p "Search or workspace:")
[ -z "$input" ] && exit 1

prefix=$(echo "$input" | awk '{print $1}')
query=$(echo "$input" | cut -d' ' -f2- | xargs)

# -----------------------------
# Workspace direct switch
# -----------------------------
if [[ -n "${ws_map[$prefix]}" ]]; then
    # Switch to workspace
    qtile cmd-obj -o group -f toscreen -a "${ws_map[$prefix]}"
    exit 0
fi

# -----------------------------
# Move focused window to workspace
# -----------------------------
if [[ "$prefix" == "move" ]]; then
    if [[ -n "${ws_map[$query]}" ]]; then
        # Move current window to workspace
        qtile cmd-obj -o window -f togroup -a "${ws_map[$query]}"
        exit 0
    else
        notify-send "Unknown workspace '$query'"
        exit 1
    fi
fi

# -----------------------------
# URL or action prefixes
# -----------------------------
case "$prefix" in
c) url="https://chat.openai.com/?q=$query" ;;
r) url="https://reddit.com/r/$query" ;;
d) url="https://duckduckgo.com/?q=$query" ;;
b) url="https://search.brave.com/search?q=$query" ;;
w) url="https://en.wikipedia.org/wiki/$query" ;;
y) url="https://www.youtube.com/results?search_query=$query" ;;
g) url="https://github.com/search?q=$query" ;;
x) qtile cmd-obj -o window -f kill ;;              # close focused window
f) qtile cmd-obj -o window -f toggle_fullscreen ;; # toggle fullscreen
wifi) ~/.local/bin/rofi-wifi.sh ;;
m) ~/.local/bin/rofipl2.sh ;;
sc) gnome-screenshot ;;
*) notify-send "Unknown prefix '$prefix'" && exit 1 ;;
esac

# -----------------------------
# Open URL if defined
# -----------------------------
[ -n "$url" ] && xdg-open "$url"
