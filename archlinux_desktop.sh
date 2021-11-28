#!/usr/bin/env bash
function __internal_pacman_install() {
    if pacman -Q "$1" | grep -i "$1" >/dev/null 2>&1; then
        echo "pacman already installed [$1]"
    else
        echo "sudo pacman -S $1 --noconfirm"
        sudo pacman -S "$1" --noconfirm
    fi
}
function __internal_pacman_group_install() {
    if pacman -Qg "$1" | grep -i "$1" >/dev/null 2>&1; then
        echo "pacman already installed [$1]"
    else
        echo "sudo pacman -S $1 --noconfirm"
        sudo pacman -S "$1" --noconfirm
    fi
}
function __internal_yay_install() {
    if yay -Q "$1" | grep -i "$1" >/dev/null 2>&1; then
        echo "yay already installed [$1]"
    else
        echo "yay -S $1 --noconfirm"
        yay -S "$1" --noconfirm
    fi
}
__internal_pacman_install xorg
__internal_pacman_group_install xfce4
__internal_pacman_group_install xfce4-goodies
__internal_pacman_group_install lightdm
__internal_pacman_group_install lightdm-gtk-greeter
sudo systemctl enable lightdm
