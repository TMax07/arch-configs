#!/bin/bash

#####################################################
# Helper functions

function if_not_dir_mk_dir() {
    if [[ -d "$1" ]]
    then
        return
    else
        sudo mkdir "$1"
    fi
}

function if_file_exists_rm() {
    if [[ -f "$1" ]] 
    then
        sudo rm -f "$1"
    fi 
}

function link_config_to_dir() {
    sudo ln -s "$1" "$2"
}

#####################################################

echo "Setting up Hyprland..."

USER="${whoami}"
if_not_dir_mk_dir "/home/$USER/.config"
if_not_dir_mk_dir "/home/$USER/.config/hypr"
if_file_exists_rm "/home/$USER/.config/hypr/hyprland.conf"
link_config_to_dir "/config/hyprland/hyprland.conf" "/home/$USER/.config/hypr/hyprland.conf"

echo "Fixing potential Spotify issues..."
if_not_dir_mk_dir "/home/$USER/.config"
if_file_exists_rm "/home/$USER/spotify-launcher.conf"
link_config_to_dir "/config/hyprland/external/spotify.conf" "/home/$USER/spotify-launcher.conf"

echo "Cannot make some changes to firefox, please look at your home directory"
sudo cp /config/hyprland/external/README_FIREFOX "/home/$USER/"