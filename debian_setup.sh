#!/usr/bin/env bash
touch ~/.hushlogin
apt update && apt upgrade
apt remove -y nano
apt install -y vim
apt install -y apt-listchanges
apt install -y autoconf
apt install -y automake
apt install -y bat
apt install -y btrfs-progs
apt install -y build-essential
apt install -y certbot
apt install -y cryptsetup
apt install -y fd-find
apt install -y fzf
apt install -y git
apt install -y iftop
apt install -y iperf3
apt install -y libblas-dev
apt install -y libcurl4-openssl-dev
apt install -y libgmp-dev
apt install -y liblapack-dev
apt install -y libmpfr-dev
apt install -y libssl-dev
apt install -y libtool
apt install -y mlocate
apt install -y openjdk-8-jdk
apt install -y systemd-coredump
apt install -y traceroute
apt install -y tree
apt install -y ufw
apt install -y unattended-upgrades
apt install -y usermod
apt install -y wget
apt install -y wireguard
apt install -y xfsprogs
apt install -y zfsutils-linux
apt install -y zlib1g-dev
apt install -y zsh

# Add user
useradd -m build
usermod -aG sudo build
cp -r ~/.ssh /home/build/
chown -R build:build /home/build/.ssh
chmod -R 700 /home/build/.ssh
touch /home/build/.hushlogin
chown build:build /home/build/.hushlogin

# Install docker
apt install -y ca-certificates
apt install -y curl
apt install -y gnupg
apt install -y lsb-release
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
apt update
apt-get install -y docker-ce docker-ce-cli containerd.io
/sbin/groupadd docker
usermod -aG docker build
systemctl enable docker
systemctl start docker

# Install firewall
ufw disable
ufw allow 22
ufw allow from 172.17.0.0/16
ufw allow from 172.17.0.0/16
ufw allow from 192.168.0.0/24
ufw allow from 192.168.5.0/16
echo "y" | ufw enable
