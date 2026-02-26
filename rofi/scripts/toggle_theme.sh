#!/bin/bash

if [ $# -eq 0 ]; then
  echo 'Dark Theme'
  echo 'Light Theme'
  exit 0
fi

case "$*" in
'Dark Theme')
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  pkill -HUP xsettingsd
  ;;
'Light Theme')
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
  pkill -HUP xsettingsd
  ;;
*)
  exit 1
  ;;
esac
