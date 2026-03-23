#!/usr/bin/env bash
# Waybar custom network module
# Outputs JSON: { "text": "...", "tooltip": "...", "class": "..." }

IFACE="wlp0s20f3"

# Check if interface is up
if ! ip link show "$IFACE" up &>/dev/null; then
    printf '{"text":" disconnected","tooltip":"Interface down","class":"disconnected"}\n'
    exit 0
fi

# Try to get wifi info via nmcli
WIFI=$(nmcli -t -f active,ssid,signal dev wifi 2>/dev/null | grep "^yes:")
if [[ -n "$WIFI" ]]; then
    SSID=$(echo "$WIFI" | cut -d: -f2)
    SIGNAL=$(echo "$WIFI" | cut -d: -f3)

    # Signal icon based on strength
    if   [[ $SIGNAL -ge 80 ]]; then ICON=""
    elif [[ $SIGNAL -ge 60 ]]; then ICON=""
    elif [[ $SIGNAL -ge 40 ]]; then ICON=""
    elif [[ $SIGNAL -ge 20 ]]; then ICON=""
    else ICON=""
    fi

    IP=$(ip -4 addr show "$IFACE" | awk '/inet /{print $2}' | cut -d/ -f1)
    printf '{"text":"%s %s","tooltip":"%s\\nSignal: %s%%\\nIP: %s","class":"wifi"}\n' \
        "$ICON" "$SSID" "$SSID" "$SIGNAL" "$IP"
    exit 0
fi

# Fallback: wired/no wifi
IP=$(ip -4 addr show "$IFACE" 2>/dev/null | awk '/inet /{print $2}' | cut -d/ -f1)
if [[ -n "$IP" ]]; then
    printf '{"text":" %s","tooltip":"Wired: %s","class":"ethernet"}\n' "$IP" "$IP"
else
    printf '{"text":"󰤮 disconnected","tooltip":"No connection","class":"disconnected"}\n'
fi
