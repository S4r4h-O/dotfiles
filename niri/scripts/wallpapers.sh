#!/bin/bash

WPP_DIR="$HOME/.config/wallpapers/"

CHOICE=$(for f in "$WPP_DIR"/*.{jpg,png}; do
  name=$(basename "$f")
  printf "%s\0icon\x1fthumbnail://%s\n" "$name" "$f"
done | rofi -dmenu -show-icons)

[ -z "$CHOICE" ] && exit 1

echo "Changing wallpaper to $WPP_DIR/$CHOICE"

ln -sf "$WPP_DIR/$CHOICE" "$HOME/.config/wallpapers/current"

if ! command -v systemctl >/dev/null ||
  ! systemctl --user restart swaybg.service ||
  ! systemctl --user daemon-reload; then
  pkill swaybg
  exec swaybg -m fill -i "$HOME/.config/wallpapers/current"
fi
