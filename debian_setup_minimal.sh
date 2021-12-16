#!/usr/bin/env bash
function installZsh() {
    curl https://raw.githubusercontent.com/ng5/os/main/.zshenv >"$HOME"/.zshenv
    curl https://raw.githubusercontent.com/ng5/os/main/.zshrc >"$HOME"/.zshrc
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo "already installed [ohmyzsh]"
    fi
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

}
function addUser() {
    touch ~/.hushlogin
    # Add user
    /sbin/groupadd -f systemd-journal-remote
    /sbin/useradd -m build
    /sbin/usermod -aG docker,sudo,systemd-journal,systemd-journal-remote build

    cp -r ~/.ssh /home/build/
    chown -R build:build /home/build/.ssh
    chmod -R 700 /home/build/.ssh
    touch /home/build/.hushlogin
    chown build:build /home/build/.hushlogin
    /sbin/usermod -aG build

    # change shell to zsh
    /sbin/usermod --shell /usr/bin/zsh build
    /sbin/usermod --shell /usr/bin/zsh root

    installZsh
    su build -c "bash -c installZsh"
}

function installPackages() {
    apt update && apt upgrade
    apt remove -y nano
    apt install -y apt-listchanges bat certbot fd-find fzf gdb git iftop iperf3 manpages manpages-dev mlocate redis-server postgresql-client ripgrep systemd-coredump traceroute tree ufw unattended-upgrades wget wireguard xfsprogs zsh vim

    # Install docker
    apt install -y ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    apt update
    apt-get install -y docker-ce docker-ce-cli containerd.io
    /sbin/groupadd docker

    # install docker-compose
    composeUrl=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -i browser_download_url | grep -i "docker-compose-Linux-x86_64\"" | cut -d '"' -f 4)
    curl -L -o /usr/local/bin/docker-compose "$composeUrl"
    chmod +x /usr/local/bin/docker-compose

}

function setupFirewall() {
    ufw disable
    ufw allow 22
    ufw allow from 172.17.0.0/16
    ufw allow from 172.17.0.0/16
    ufw allow from 172.18.0.0/16
    ufw allow from 192.168.1.0/24
    ufw allow from 192.168.5.0/16

    # fix docker firewall problems
    sed -i -e 's/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/g' /etc/default/ufw

    if ! grep -i -q "dockerfix" /etc/ufw/before.rules; then
        cat >>/etc/ufw/before.rules <<EOL
# dockerfix - NAT Rules
*nat
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING ! -d 172.16.0.0/16 -s 172.16.0.0/16 -j MASQUERADE
-A POSTROUTING ! -d 172.17.0.0/16 -s 172.17.0.0/16 -j MASQUERADE
-A POSTROUTING ! -d 172.18.0.0/16 -s 172.18.0.0/16 -j MASQUERADE
COMMIT
EOL
    fi

    cat >/etc/docker/daemon.json <<EOL
{
	"iptables":false,
    "insecure-registries" : [ "da01:8082" ]
}
EOL
}

function setupNetwork() {
    sed -i -e 's/.*PermitRootLogin.*/PermitRootLogin no # Auto-edited by debian_setup_minimal.sh/I' /etc/ssh/sshd_config
    sed -e 's/.*PasswordAuthentication.*/PasswordAuthentication no # Auto-edited by debian_setup_minimal.sh/I' /etc/ssh/sshd_config
    if ! grep -i -q "da hosts" /etc/hosts; then
        cat >>/etc/hosts <<EOL
192.168.5.1 da01 da01.ln.lan
192.168.5.2 da02 da02.ln.lan
EOL
    fi
}

function services() {
    echo "y" | ufw enable
    systemctl stop redis
    systemctl disable redis
    systemctl enable docker
    systemctl restart docker
}

export -f installZsh
installPackages
addUser
setupNetwork
setupFirewall
services
