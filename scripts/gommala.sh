#!/usr/bin/env bash

# tmux-fzf-dashboard.sh - Unified Tmux Dashboard with FZF
# Requirements: tmux, fzf, bash, coreutils

HOME_SESSION="home"

# Generate a clean session name from a directory
dir_to_session() {
    local dir="$1"
    local rel="${dir/#$HOME\//}"
    echo "${rel//[^a-zA-Z0-9]/_}"
}

# List existing tmux sessions with details
list_sessions() {
    tmux list-sessions -F "#{session_name}|#{window_count}|#{session_created}|#{session_attached}" 2>/dev/null |
        awk -F'|' '{
      cmd="date -d @"$3" +%Y-%m-%d_%H:%M:%S"; cmd | getline d; close(cmd);
      printf "%-20s  windows:%-2s  created:%s  attached:%s\n", $1, $2, d, $4;
    }'
}

# Find directories under $HOME excluding standard cache/config dirs
list_dirs() {
    find "$HOME" -maxdepth 2 -type d \
        -not -path "*/.cache*" \
        -not -path "*/.config*" \
        -not -path "*/.local*" \
        -not -path "*/.git*" \
        -not -path "$HOME" |
        sort
}

# Attach or create a session for a directory
open_dir_session() {
    local dir="$1"
    local session
    session=$(dir_to_session "$dir")
    if ! tmux has-session -t "$session" 2>/dev/null; then
        tmux new-session -ds "$session" -c "$dir"
    fi
    exec tmux attach -t "$session"
}

# Open "Home" session
open_home() {
    if ! tmux has-session -t "$HOME_SESSION" 2>/dev/null; then
        tmux new-session -ds "$HOME_SESSION" -c "$HOME"
    fi
    exec tmux attach -t "$HOME_SESSION"
}

# Interactive delete of sessions
delete_sessions() {
    local selected
    selected=$(list_sessions | fzf --multi --header "Select sessions to delete (TAB to mark, ENTER to confirm)" |
        awk '{print $1}')
    for s in $selected; do
        tmux kill-session -t "$s"
    done
}

# Dashboard main menu
dashboard() {
    local choice
    choice=$( (
        echo "[Home]"
        echo "[Delete]"
        list_sessions
        list_dirs
    ) |
        fzf --header "tmux-fzf-dashboard" --expect=enter --cycle --bind 'j:down,k:up,q:abort')

    [ -z "$choice" ] && exit 0

    local selected
    selected=$(echo "$choice" | tail -n +2)

    case "$selected" in
    "[Home]") open_home ;;
    "[Delete]") delete_sessions ;;
    *)
        if echo "$selected" | grep -q "^ "; then
            # It's a session line
            local sess
            sess=$(echo "$selected" | awk '{print $1}')
            exec tmux attach -t "$sess"
        else
            open_dir_session "$selected"
        fi
        ;;
    esac
}

dashboard
