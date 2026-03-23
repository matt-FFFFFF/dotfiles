#!/usr/bin/env bash
# Waybar custom bluetooth module

POWERED=$(bluetoothctl show 2>/dev/null | awk '/Powered:/{print $2}')

if [[ "$POWERED" != "yes" ]]; then
    printf '{"text":"󰂲","tooltip":"Bluetooth off","class":"off"}\n'
    exit 0
fi

CONNECTED=$(bluetoothctl devices Connected 2>/dev/null | head -1 | cut -d' ' -f3-)

if [[ -n "$CONNECTED" ]]; then
    printf '{"text":"󰂱 %s","tooltip":"Connected: %s","class":"connected"}\n' "$CONNECTED" "$CONNECTED"
else
    printf '{"text":"󰂯","tooltip":"Bluetooth on","class":"on"}\n'
fi
