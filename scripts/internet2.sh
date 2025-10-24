#!/bin/bash

# Set your rofi theme file here
ROFI_THEME="$HOME/.config/rofi/themes/spot.rasi"

# Enable fuzzy matching (default is case-insensitive)
ROFI_OPTS="-theme $ROFI_THEME -matching fuzzy -i"

# List of search engines
engine=$(printf "DuckDuckGo\nBrave\nWikipedia\nYouTube\nGitHub" | rofi -dmenu $ROFI_OPTS -p "Search with:")
[ -z "$engine" ] && exit 1

# Get search query
query=$(rofi -dmenu $ROFI_OPTS -p "Query:")
[ -z "$query" ] && exit 1

# Construct URL based on selected engine
url=$(case "$engine" in
    DuckDuckGo) echo "https://duckduckgo.com/?q=$query" ;;
    Brave) echo "https://search.brave.com/search?q=$query" ;;
    Wikipedia) echo "https://en.wikipedia.org/wiki/$query" ;;
    YouTube) echo "https://www.youtube.com/results?search_query=$query" ;;
    GitHub) echo "https://github.com/search?q=$query" ;;
    esac)

# Open the selected URL
xdg-open "$url"
