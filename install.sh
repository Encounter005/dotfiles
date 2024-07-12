#! /bin/bash

# current directory

source=$(pwd)
target=~/.config/
target2=~/
shell_files=".zshrc .tmux.conf .vimrc night-owl.json motd.sh"
exclude_files="README.md .git install.sh .gitignore "

Link() {
    if [ -L "$3/$1" ]; then
        echo "Link $3/$1 already exists, skipping"
    else
        ln -s "$2" "$3/$1"
    fi
}

for d in "$source"/*; do
    # get the name of sub directory
    dir_name=$(basename "$d")
    
    if [[ $exclude_files = *"$dir_name"* ]]; then
        continue;
    fi

    if [[ $shell_files = *"$dir_name"* ]]; then
        Link $dir_name $d $target2
    else
        Link $dir_name $d $target
    fi

done

for d in "$source"/.*; do
    dir_name=$(basename "$d")

    if [[ $exclude_files = *"$dir_name"* ]]; then
        continue;
    fi

    Link $dir_name $d $target2
done

