#!/usr/bin/env bash
function __internal_pacman_install() {
    if pacman -Q "$1" | grep -i "$1" >/dev/null 2>&1; then
        echo "already installed [$1]"
    else
        echo "sudo pacman -S $1"
        sudo pacman -S "$1"
    fi
}
function __internal_pacman_group_install() {
    if pacman -Qg "$1" | grep -i "$1" >/dev/null 2>&1; then
        echo "already installed [$1]"
    else
        echo "sudo pacman -S $1"
        sudo pacman -S "$1"
    fi
}
__internal_pacman_install "firefox"
__internal_pacman_install "ttf-roboto"
__internal_pacman_install "ttf-roboto-mono"
__internal_pacman_install "ttf-jetbrains-mono"
__internal_pacman_install "iw"
__internal_pacman_install "iwd"
__internal_pacman_install "git"
__internal_pacman_install "pulseaudio"
__internal_pacman_install "pulseaudio-bluetooth"
__internal_pacman_install "mesa-demos"
__internal_pacman_install "nvidia-prime"
__internal_pacman_install "nvidia-settings"
__internal_pacman_install "muparser"
__internal_pacman_install "mlocate"
__internal_pacman_install "google-chrome"
__internal_pacman_install "linux-lts"
__internal_pacman_install "linux-lts-headers"
__internal_pacman_install "linux-zen"
__internal_pacman_install "linux-zen-headers"
__internal_pacman_install "arc-gtk-theme"
__internal_pacman_install "bluez"
__internal_pacman_install "bluez-utils"
__internal_pacman_install "blueman"
__internal_pacman_group_install "base-devel"
__internal_pacman_install "redis"
__internal_pacman_install "docker"
__internal_pacman_install "docker-compose"
__internal_pacman_install "papirus-icon-theme"
__internal_pacman_install "zsh"
__internal_pacman_install "terminator"
__internal_pacman_install "shfmt"
__internal_pacman_install "shellcheck"
