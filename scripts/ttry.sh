#!/usr/bin/bash

list-sessions(){
    tmux list-sessions | fzf
}

selected = $(list-sessions)

tmux a -t "$selected"
