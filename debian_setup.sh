#!/usr/bin/env bash

function installZsh() {

    curl https://raw.githubusercontent.com/ng5/os/main/.zshenv >"$HOME"/.zshenv
    curl https://raw.githubusercontent.com/ng5/os/main/.zshrc >"$HOME"/.zshrc
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
}
export -f installZsh
touch ~/.hushlogin
apt update && apt upgrade
apt remove -y nano
apt install -y vim apt-listchanges autoconf automake bat btrfs-progs build-essential certbot cryptsetup fd-find fzf git iftop iperf3 libblas-dev libcurl4-openssl-dev libgmp-dev liblapack-dev libmpfr-dev libssl-dev libtool mlocate openjdk-11-jdk systemd-coredump traceroute tree ufw unattended-upgrades
wget wireguard xfsprogs zfsutils-linux ripgrep zlib1g-dev zsh bpfcc-tools python-bpfcc libbpfcc clang clang-format llvm gdb

# Add user
/sbin/useradd -m build
/sbin/usermod -aG sudo build
cp -r ~/.ssh /home/build/
chown -R build:build /home/build/.ssh
chmod -R 700 /home/build/.ssh
touch /home/build/.hushlogin
chown build:build /home/build/.hushlogin

# change shell to zsh
/sbin/usermod --shell /usr/bin/zsh build
/sbin/usermod --shell /usr/bin/zsh root

# Install docker
apt install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
apt update
apt-get install -y docker-ce docker-ce-cli containerd.io
/sbin/groupadd docker
/sbin/usermod -aG docker build
systemctl enable docker
systemctl restart docker

# Install firewall
ufw disable
ufw allow 22
ufw allow from 172.17.0.0/16
ufw allow from 172.17.0.0/16
ufw allow from 192.168.0.0/24
ufw allow from 192.168.5.0/16
echo "y" | ufw enable

installZsh
su build -c "bash -c installZsh"
