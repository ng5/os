#!/usr/bin/env bash
touch ~/.hushlogin
apt update && apt upgrade
apt remove -y nano
apt install -y vim apt-listchanges autoconf automake bat btrfs-progs build-essential certbot cryptsetup fd-find fzf git iftop iperf3 libblas-dev libcurl4-openssl-dev libgmp-dev liblapack-dev libmpfr-dev libssl-dev libtool mlocate openjdk-8-jdk systemd-coredump traceroute tree ufw unattended-upgrades usermod wget wireguard xfsprogs zfsutils-linux zlib1g-dev zsh

# Add user
useradd -m build
usermod -aG sudo build
cp -r ~/.ssh /home/build/
chown -R build:build /home/build/.ssh
chmod -R 700 /home/build/.ssh
touch /home/build/.hushlogin
chown build:build /home/build/.hushlogin

# change shell to zsh
usermod --shell /usr/bin/zsh build
usermod --shell /usr/bin/zsh root

# Install docker
apt install -y ca-certificates curl gnupg lsb-release
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

# Install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
su - build
cd /home/build || return
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
