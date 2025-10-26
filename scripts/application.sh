#!/usr/bin/env bash

# Zen
if ! pgrep -x zen >/dev/null; then
    zen &
fi
