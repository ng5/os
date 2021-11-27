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
# General use packages
__internal_pacman_install "wget"
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
__internal_pacman_install "papirus-icon-theme"

# Development packages
__internal_pacman_install "jdk8-openjdk"
__internal_pacman_install "redis"
__internal_pacman_install "docker"
__internal_pacman_install "docker-compose"
__internal_pacman_install "zsh"
__internal_pacman_install "terminator"
__internal_pacman_install "shfmt"
__internal_pacman_install "shellcheck"
__internal_pacman_install "npm"
__internal_pacman_install "nodejs"
__internal_pacman_install "lapack"
__internal_pacman_install "blas"
__internal_pacman_install "cmake"
__internal_pacman_install "xfsprogs"
__internal_pacman_install "btrfs-progs"
__internal_pacman_install "postgresql"
__internal_pacman_install "clang"
__internal_pacman_install "mkcert"

# Install AUR helper yay
if [[ ! -d "$HOME/yay-git" ]]; then
    git clone https://aur.archlinux.org/yay-git.git "$HOME"/yay-git
    cd yay-git || return
    makepkg -si
fi
__internal_yay_install brave-bin
__internal_yay_install optimus-manager
__internal_yay_install albert
__internal_yay_install google-chrome
__internal_yay_install arc-icon-theme-git
__internal_yay_install numix-circle-icon-theme-git
__internal_yay_install arc-icon-theme-git
__internal_yay_install icaclient

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "already installed [ohmyzsh]"
    if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/fzf-tab" ]]; then
        git clone https://github.com/Aloxaf/fzf-tab "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/fzf-tab
    fi
    if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
    fi
    if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
    fi
    if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zfs-completion" ]]; then
        git clone https://github.com/luoxu34/zfs-completion.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zfs-completion
    fi
fi

# These 7 programs seem to be spyware provided by Citrix
sudo mv /opt/Citrix/ICAClient/AuthManagerDaemon /opt/Citrix/ICAClient/AuthManagerDaemon_Deleted 2>/dev/null
sudo mv /opt/Citrix/ICAClient/icasessionmgr_Deleted /opt/Citrix/ICAClient/icasessionmgr_Deleted_Deleted 2>/dev/null
sudo mv /opt/Citrix/ICAClient/NativeMessagingHost /opt/Citrix/ICAClient/NativeMessagingHost_Deleted 2>/dev/null
sudo mv /opt/Citrix/ICAClient/PrimaryAuthManager /opt/Citrix/ICAClient/PrimaryAuthManager_Deleted 2>/dev/null
sudo mv /opt/Citrix/ICAClient/selfservice /opt/Citrix/ICAClient/selfservice_Deleted 2>/dev/null
sudo mv /opt/Citrix/ICAClient/ServiceRecord /opt/Citrix/ICAClient/ServiceRecord_Deleted 2>/dev/null
sudo mv /opt/Citrix/ICAClient/UtilDaemon /opt/Citrix/ICAClient/UtilDaemon_Deleted 2>/dev/null

# Timezone file
sudo rm -rf /etc/timezone
sudo ln -s /usr/share/zoneinfo/Europe/London /etc/timezone
