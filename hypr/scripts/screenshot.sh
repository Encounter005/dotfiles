#!/usr/bin/env sh

save_dir="$HOME/Pictures/tmp"
save_file=$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')

if [ ! -d "$save_dir" ]; then
    mkdir -p $save_dir
fi

case $1 in
p) grim ${save_dir}/${save_file} ;;
s) grim -g "$(slurp)" - | swappy -f - ;;
*)
    echo "...valid options are..."
    echo "p : print screen to $save_dir"
    echo "s : snip current screen to $save_dir"
    exit 1
    ;;
esac

if [ -f "$save_dir/$save_file" ]; then
    echo "enter"
    dunstify "saved in $save_dir" -i "$save_dir/$save_file" -r 91190 -t 2200
fi
