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

echo "Running nvidia setup..."

if_not_dir_mk_dir "/etc/modprobe.d"
if_file_exists_rm "/etc/modprobe.d/nvidia.conf"
link_config_to_dir "/config/nvidia/modprobe.conf" "/etc/modprobe.d/nvidia.conf"

LOAD_MODULES="nvidia nvidia_modeset nvidia_uvm nvidia_drm"
if lscpu | grep -q Intel
then
    echo "Found an intel cpu, loading iGPU modules early..."
    LOAD_MODULES="i915 $LOAD_MODULES"
fi

sudo sed -i "s/MODULES=(/MODULES=($LOAD_MODULES /g" /etc/mkinitcpio.conf
sudo mkinitcpio -P

echo "Fixing possible resume issues..."
sudo systemctl enable --now nvidia-suspend.service
sudo systemctl enable --now nvidia-hibernate.service
sudo systemctl enable --now nvidia-resume.service

sed -i '/^option/s/$/ nvidia.NVreg_PreserveVideoMemoryAllocations=1/' /boot/loader/entries/9-arch.conf