#!/bin/sh

lock="Lock"
logout="Logout (Sway)"
suspend="Sleep"
reboot="Reboot"
shutdown="Shutdown"

selected_option=$(echo "$shutdown
$reboot
$lock
$suspend
$logout" | fuzzel -d -p "Power: " --lines 5 --width 25)

case "$selected_option" in
    "$lock")
        swaylock ;;
    "$logout")
        swaymsg exit ;;
    "$suspend")
        loginctl suspend ;; 
    "$reboot")
        loginctl reboot ;;
    "$shutdown")
        loginctl poweroff ;;
    *)
        echo "No action selected" ;;
esac
