#!/usr/bin/env bash
function __internal_pacman_install() {
    if pacman -Q | grep -i "$1" >/dev/null 2>&1; then
        echo "already installed [$1]"
    else
        echo "sudo pacman -S $1"
        sudo pacman -S "$1"
    fi
}
__internal_pacman_install "zsh"
