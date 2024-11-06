#!/bin/bash

# packages
yay -S yayfzf nvidia-dkms nvidia-utils hyprland waybar xdg-desktop-portal-hyprland libinput-gestures downgrade\
neovim pipewire  pipewire-alsa pipewire-jack  pipewire-audio pipewire-pulse wireplumber pavucontrol pamixer networkmanager\
network-manager-applet bluez bluez-utils blueman brightnessctl udiskie sddm qt5-quickcontrols qt5-quickcontrols2\
qt5-graphicaleffects  rofi-wayland  swww swaylock-effects-git wlogout grimblast-git swappy cliphist slurp polkit-gnome \
xdg-desktop-portal-gtk  pacman-contrib parallel jq imagemagick deno nemo libnotify nwg-drawer qt5ct qt6ct kvantum kvantum-qt5 \
qt5-wayland qt6-wayland  kitty ark vim code yazi zsh oh-my-zsh-git neofetch bat alacritty cava btop bottom swaylock zathura zellij oh-my-posh nfs-utils egl-wayland


# Define the source and target directories
source_dir=$(pwd)
target_dir="$HOME/.config"
shell_target_dir="$HOME"

# Define arrays for shell files and exclude files
declare -a shell_files=(".zshrc" ".tmux.conf" ".vimrc" "night-owl.json" "motd.sh" "clean-detailed.omp.json" "install_yay.sh")
declare -a exclude_files=("README.md" ".git" "install.sh" ".gitignore")

# Function to create a symbolic link if it does not exist
link_files() {
    local file_name="$1"
    local source_path="$2"
    local target_path="$3"

    if [ ! -e "$target_path/$file_name" ] || [ ! -L "$target_path/$file_name" ]; then
        ln -s "$source_path" "$target_path/$file_name"
        echo "Linked $source_path -> $target_path/$file_name"
    else
        echo "Link $target_path/$file_name already exists, skipping."
    fi
}

# Process directories and files
for item in "$source_dir"/* "$source_dir"/.*; do
    # Get the name of the subdirectory or file
    item_name=$(basename "$item")

    # Skip excluded files and directories
    if [[ " ${exclude_files[@]} " =~ " ${item_name} " ]]; then
        continue
    fi

    # Check if the item is a shell file
    if [[ " ${shell_files[@]} " =~ " ${item_name} " ]]; then
        link_files "$item_name" "$item" "$shell_target_dir"
    else
        link_files "$item_name" "$item" "$target_dir"
    fi
done
