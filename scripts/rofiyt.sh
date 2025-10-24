#!/bin/bash

THEME="demnu"
MUSIC_DIR="$HOME/Music"

# Numbered main menu
mode=$(printf "1. 🎵 Local Music\n2. 🌐 YouTube Music" | rofi -dmenu -theme "$THEME" -p "Select [1-2]")

[ -z "$mode" ] && exit

case "$mode" in
    1*|🎵*)
        cd "$MUSIC_DIR" || exit

        tracks=$(find . -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.m4a" \) | sed 's|^\./||')

        selected=$(echo "$tracks" | rofi -dmenu -theme "$THEME" -p "🎧 Select Track")

        [ -z "$selected" ] && exit

        mpv "$MUSIC_DIR/$selected"
        ;;

    2*|🌐*)
        query=$(rofi -dmenu -theme "$THEME" -p "🔍 Search YouTube Music")
        [ -z "$query" ] && exit

        # Use yt-dlp to get title and URL pairs
        mapfile -t results < <(yt-dlp "ytsearch10:$query" --print "%(title)s | %(webpage_url)s" --quiet)

        # Show titles only
        mapfile -t titles < <(printf "%s\n" "${results[@]}" | cut -d "|" -f1 | sed 's/ *$//')

        selected_title=$(printf "%s\n" "${titles[@]}" | rofi -dmenu -theme "$THEME" -p "🎧 Choose song")
        [ -z "$selected_title" ] && exit

        # Find the URL that matches the selected title (by index)
        index=$(printf "%s\n" "${titles[@]}" | grep -nxF "$selected_title" | cut -d ":" -f1)
        url=$(printf "%s\n" "${results[$((index - 1))]}" | cut -d "|" -f2 | xargs)

        # Stream via mpv
        if [ -n "$url" ]; then
            mpv "$url" --no-video --title="$selected_title"
        else
            notify-send "❌ Could not find video URL"
        fi
        ;;
esac
