#!/bin/bash
ACTION=$1
ICON="$HOME/.config/kitty/miku-notify.png"
case $ACTION in
    copy)
        MESSAGES=(
            "Sip atuh, geus di-copy téh euy!"
            "Mantap, datana geus nyimpen di clipboard"
            "Oke gas, téks na geus kasimpen"
            "Wado, siap di-paste mah kapan waé"
            "Alus, geus dicatet di memori téh"
            "Jos, tinggal tamplok waé da nanti"
            "Udah nih, geus aya di clipboard"
            "Geus di-copy euy, paste waé lamun rék"
            "Sip lah, datana mah geus aman"
        )
        ;;
    paste)
        MESSAGES=(
            "Mantul euy, geus nempel téh!"
            "Sip atuh, paste na geus jadi"
            "Jos, téks na geus asup kabéh"
            "Oke fix, geus ditamplok da téh"
            "Alus, datana mah geus mlebet"
            "Wado, udah nempel euy tadi"
            "Bérés atuh, geus nyangking téh"
            "Mantap, paste na geus suksés"
        )
        ;;
esac
MSG=${MESSAGES[$RANDOM % ${#MESSAGES[@]}]}
# Dengan custom icon
notify-send "Miku Assistant" "$MSG" -i "$ICON" -t 2200 -u low
