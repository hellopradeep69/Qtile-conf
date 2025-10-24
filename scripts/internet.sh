#!/bin/bash

# ==============================
# Config
# ==============================
ROFI_THEME="$HOME/.config/rofi/themes/spot.rasi"
ROFI_THEME2="$HOME/.config/rofi/themes/demnu.rasi"

ROFI_OPTS="-theme $ROFI_THEME -matching fuzzy -i"
ROFI_OPTS2="-theme $ROFI_THEME2 -matching fuzzy -i"

# ==============================
# Workspace word mapping
# ==============================
declare -A ws_map=(
    ["one"]=1
    ["two"]=2
    ["three"]=3
    ["four"]=4
    ["five"]=5
    ["six"]=6
    ["seven"]=7
    ["eight"]=8
    ["nine"]=9
    ["zero"]=0
    ["on"]=1
    ["tw"]=2
    ["th"]=3
    ["fo"]=4
    ["fi"]=5
    ["si"]=6
    ["se"]=7
    ["ei"]=8
    ["ni"]=9
    ["ze"]=0

)

# ==============================
# Prompt for input
# ==============================
input=$(rofi -dmenu $ROFI_OPTS -p "Search (c,r,d,y,w,g,b)")

[ -z "$input" ] && exit 1

# Extract prefix (first word) and query (rest)
prefix=$(echo "$input" | awk '{print $1}')
query=$(echo "$input" | cut -d' ' -f2- | xargs)

# ==============================
# Workspace direct switch
# ==============================
if [[ -n "${ws_map[$prefix]}" ]]; then
    bspc desktop -f "${ws_map[$prefix]}"
    exit 0
fi

# ==============================
# Move focused window to workspace
# ==============================
if [[ "$prefix" == "move" ]]; then
    # Example: "move one" -> move focused node to workspace 1
    if [[ -n "${ws_map[$query]}" ]]; then
        bspc node -d "${ws_map[$query]}"
        exit 0
    else
        notify-send "Unknown workspace '$query'"
        exit 1
    fi
fi

# ==============================
# Handle prefixes
# ==============================
case "$prefix" in
c) url="https://chat.openai.com/?q=$query" ;;
r) url="https://reddit.com/r/$query" ;;
d) url="https://duckduckgo.com/?q=$query" ;;
b) url="https://search.brave.com/search?q=$query" ;;
w) url="https://en.wikipedia.org/wiki/$query" ;;
y) url="https://www.youtube.com/results?search_query=$query" ;;
g) url="https://github.com/search?q=$query" ;;
go) .local/bin/workspace.sh ;;
x) bspc node -c ;;
sc) gnome-screenshot ;;
m) ~/.local/bin/rofipl2.sh ;;
wifi) ~/.local/bin/rofi-wifi.sh ;;
f) bspc node -t ~fullscreen ;;

*) notify-send "Unknown input '$prefix'" && exit 1 ;;
esac

# ==============================
# Open in browser
# ==============================
xdg-open "$url"
# ------------------------------old one --------------------------------------------------

##!/bin/bash
#
## Set your rofi theme file here
#ROFI_THEME="$HOME/.config/rofi/themes/spot.rasi"
#ROFI_THEME2="$HOME/.config/rofi/themes/demnu.rasi"
#
## Rofi options
#ROFI_OPTS="-theme $ROFI_THEME -matching fuzzy -i"
#ROFI_OPTS2="-theme $ROFI_THEME2 -matching fuzzy -i"
#
## Prompt user to enter prefixed query like: c 5+5 or d chatgpt
#input=$(rofi -dmenu $ROFI_OPTS -p "Search (c, r, d, y, w, g, b)")
#
## Exit if empty
#[ -z "$input" ] && exit 1
#
## Extract prefix (first word) and query (rest)
#prefix=$(echo "$input" | awk '{print $1}')
#query=$(echo "$input" | cut -d' ' -f2-)
#
## Trim whitespace
#query=$(echo "$query" | xargs)
#
## Determine URL or action based on prefix
#case "$prefix" in
## c)
##     result=$(echo "$query" | bc -l)
##     echo "$query = $result" | rofi -dmenu $ROFI_OPTS2 -p "Result:" >/dev/null
##     exit
##     ;;
#c) url="https://chat.openai.com/?q=$query" ;;
#r) url="https://reddit.com/r/$query" ;;
#d) url="https://duckduckgo.com/?q=$query" ;;
#b) url="https://search.brave.com/search?q=$query" ;;
#w) url="https://en.wikipedia.org/wiki/$query" ;;
#y) url="https://www.youtube.com/results?search_query=$query" ;;
#g) url="https://github.com/search?q=$query" ;;
#*) notify-send "Unknown prefix '$prefix'" && exit 1 ;;
#esac
#
## Open in browser
#xdg-open "$url"
