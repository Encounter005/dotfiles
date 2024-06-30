#!/bin/bash

DIR=$HOME/Pictures/background/
PICS=($(find ${DIR} -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \)))
RANDOMPICS=${PICS[ $RANDOM % ${#PICS[@]} ]}
RANDOMPICS2=${PICS[ $RANDOM % ${#PICS[@]} ]}


change_swww() {
    swww img ${RANDOMPICS} -o eDP-1 --transition-fps 60 --transition-type grow  --transition-pos 1825,1080 --transition-duration 3
    swww img ${RANDOMPICS2} -o HDMI-A-1 --transition-fps 60 --transition-type grow  --transition-pos 2560,1440 --transition-duration 3
}

change_swww
notify-send "wallpaper change!" 

