#!/bin/bash
# chmox +x ~/.config/niri/scripts/cycle_workspaces.sh if not working
# List workspaces
# Identify current workspace
# Identify last workspace (total workspaces)
# If current % total == 0, back to first
#
# niri msg workspaces output format:
# Output "eDP-1":
# * 1
#   2
#   3

# WS = WORKSPACES
WS="$(niri msg workspaces)"

# $1 == "*" on the current workspace line
CURRENT_WS=$(awk '$1=="*" {print $2; exit}' <<<"$WS")

# Finds the highest workspace ID
# Two patterns are required:
# current workspace - $1 == "*", $2 == ID
# other workspaces - $1 == ID
# So we need to consider both cases when filtering the highest value
TOTAL_WS=$(
  awk '
    $1 == "*" { val = $2 }
    $1 ~ /^[0-9]+$/ { val = $1 }
    { if (val+0 > max) max = val+0 }
    END { print max }
  ' <<<"$WS"
)

_forward() {

  if [ $((CURRENT_WS % $TOTAL_WS)) -gt 0 ]; then
    niri msg action focus-workspace $((CURRENT_WS + 1))
  else
    niri msg action focus-workspace 1
  fi
}

_backward() {
  if [ "$((CURRENT_WS))" -eq 1 ]; then
    niri msg action focus-workspace "$TOTAL_WS"
  else
    niri msg action focus-workspace $((CURRENT_WS - 1))
  fi
}

case "$@" in
--forward)
  _forward
  ;;
--backward)
  _backward
  ;;
*)
  echo "Invalid"
  exit 1
  ;;
esac
