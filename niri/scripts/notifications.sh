show_notifications() {
  dunstctl history | jq -r '.data[0][] | "\(.summary.data) | \(.body.data)"' | rofi -dmenu -p "History"
}

case $1 in
--show)
  show_notifications
  ;;
*)
  exit 1
  ;;
esac
