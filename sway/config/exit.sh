#!/usr/bin/env bash
# Exit sway confirmation via rofi

choice=$(printf "Exit\000icon\x1fapplication-exit-symbolic\nCancel\000icon\x1fwindow-close-symbolic" | rofi -dmenu -show-icons \
  -p "Exit sway?" \
  -theme ~/.config/rofi/omarchy.rasi \
  -theme-str 'window { width: 160px; } listview { lines: 2; } inputbar { enabled: false; } element-text { vertical-align: 0.5; }' \
  -no-custom -matching prefix -i \
  -selected-row 1)

[[ "$choice" == "Exit" ]] && swaymsg exit
