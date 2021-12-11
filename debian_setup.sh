#!/usr/bin/env bash
printf "%s " "this script will update servers and install new packages (y/n)?"
read -r answer
if [ "$answer" != "y" ]; then
    exit 0
fi
apt update && apt upgrade
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

useradd -m build
usermod -aG sudo build
ufw disable
ufw allow 22
ufw allow from 172.17.0.0/16
ufw allow from 172.17.0.0/16
ufw allow from 192.168.0.0/24
ufw allow from 192.168.5.0/16
ufw enable
