#!/bin/bash

# Check status of all radios
wifi_blocked=$(rfkill list | grep -A1 "Wireless LAN" | grep "Soft blocked: yes")
bt_blocked=$(rfkill list | grep -A1 "Bluetooth" | grep "Soft blocked: yes")

if [[ -n "$wifi_blocked" && -n "$bt_blocked" ]]; then
    notify-send "✈️ Flight Mode Enabled" "All wireless communications are off."
else
    notify-send "📶 Flight Mode Disabled" "Wireless communication is on."
fi
