#!/bin/bash

declare _step=0.1
output_file="$HOME/.config/niri/config.d/outputs.kdl"

notify_user() {
  local scaling=$1
  dunstify -h string:x-dunst-stack-tag:scaling-factor \
    -h int:value:"$scaling" \
    -a "scaling-factor" \
    -u low \
    "Screen" "Scaling factor: ${scaling}"
}

# _get_text_scaling() {
#   local text_scaling
#   text_scaling=$(gsettings get org.gnome.desktop.interface text-scaling-factor)
#   printf "%.2f" "$text_scaling"
# }

# Niri currently doesn't expose a flag to display the info of the current monitor,
# so we need to retrieve it directly from the config file. `grep -m {num}` returns
# the first occurence. Yes, all the other monitors you follow this value.
_get_interface_scaling() {
  local interface_scaling
  interface_scaling=$(grep -m 1 scale "$HOME/.config/niri/config.d/outputs.kdl" | awk '{print $2}')
  printf "%.2f" "$interface_scaling"
}

# Min scaling factor is 0, max is 2 (I think).
_set_interface_scaling() {
  local scaling
  scaling=$(_get_interface_scaling)

  if [[ "$1" == "+$_step" ]]; then
    new_scaling=$(awk "BEGIN {printf \"%.2f\", $scaling + $_step}")
  elif [[ "$1" == "-$_step" ]]; then
    new_scaling=$(awk "BEGIN {printf \"%.2f\", $scaling - $_step}")
  fi

  (($(awk "BEGIN {print ($new_scaling < 0)}"))) && new_scaling="0.00"
  (($(awk "BEGIN {print ($new_scaling > 2)}"))) && new_scaling="2.00"

  # This propagates the new scaling to all the monitors. I'll find a solution
  # sometime.
  sed -i -E "s/scale [0-9]+(\.[0-9]+)?/scale $new_scaling/g" "$output_file"
  notify_user "$new_scaling"
}

case "$@" in
--inc)
  _set_text_scaling "+$_step"
  ;;
--dec)
  _set_text_scaling "-$_step"
  ;;
*)
  echo "Invalid option"
  ;;
esac
