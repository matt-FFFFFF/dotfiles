#!/usr/bin/env bash
# Exit sway confirmation via rofi

choice=$(printf "Exit\000icon\x1fapplication-exit-symbolic\nCancel\000icon\x1fwindow-close-symbolic" | rofi -dmenu -show-icons \
  -p "Exit sway?" \
  -theme ~/.config/rofi/exit.rasi \
  -no-custom -matching prefix -i \
  -selected-row 1)

[[ "$choice" == "Exit" ]] && swaymsg exit
