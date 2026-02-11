#!/usr/bin/env bash

case $* in
Lock)
  swaylock
  exit 0
  ;;
Logout)
  niri msg action quit
  exit 0
  ;;
Suspend)
  systemctl suspend
  exit 0
  ;;
Hibernate)
  systemctl hybernate
  exit 0
  ;;
Reboot)
  echo "Confirm Reboot"
  echo "Cancel"
  exit 0
  ;;
"Confirm Reboot")
  systemctl reboot
  ;;
Shutdown)
  echo "Confirm Shutdown"
  echo "Cancel"
  exit 0
  ;;
"Confirm Shutdown")
  systemd-run --on-active=30 systemctl poweroff
  notify-send "Shutdown scheduled" "System will shutdown in 60 seconds"
  exit 0
  ;;
Quit)
  exit 0
  ;;
esac

echo "Lock"
echo "Logout"
echo "Suspend"
echo "Hibernate"
echo "Reboot"
echo "Shutdown"
echo "Test"
echo "Quit"
