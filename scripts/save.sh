#!/usr/bin/env bash
# tmux-continuum.sh — minimalist auto-save & restore

SESSION_FILE="$HOME/.cache/tmux_sessions.list"
INTERVAL=60 # seconds between auto-saves

save_sessions() {
    mkdir -p "$(dirname "$SESSION_FILE")"
    tmux list-windows -a -F "#{session_name}:#{window_index}:#{pane_current_path}" >"$SESSION_FILE"
    echo "[$(date +%T)] Sessions saved to $SESSION_FILE"
}

restore_sessions() {
    [ ! -f "$SESSION_FILE" ] && echo "No saved sessions found." && exit 0
    while IFS=: read -r session win path; do
        [[ -z "$session" ]] && continue
        if ! tmux has-session -t "$session" 2>/dev/null; then
            tmux new-session -ds "$session" -c "${path:-$HOME}"
        fi
    done <"$SESSION_FILE"
    echo "Restored sessions from $SESSION_FILE"
}

auto_save_loop() {
    while true; do
        save_sessions >/dev/null 2>&1
        sleep "$INTERVAL"
    done
}

case "$1" in
--save) save_sessions ;;
--restore) restore_sessions ;;
--loop) auto_save_loop ;;
*) echo "Usage: tmux-continuum.sh [--save|--restore|--loop]" ;;
esac
