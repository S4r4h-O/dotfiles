#!/bin/bash

WPP_DIR="$HOME/Pictures/Wallpapers"

CHOICE=$(for f in "$WPP_DIR"/*.{jpg,png}; do
  name=$(basename "$f")
  printf "%s\0icon\x1fthumbnail://%s\n" "$name" "$f"
done | rofi -dmenu -show-icons)

[ -z "$CHOICE" ] && exit 1

echo "Changing wallpaper to $WPP_DIR/$CHOICE"
ln -sf "$WPP_DIR/$CHOICE" "$HOME/.config/wallpaper"

systemctl --user restart swaybg.service
systemctl --user daemon-reload
