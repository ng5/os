#!/usr/bin/env bash
function installZsh() {
    curl -s https://raw.githubusercontent.com/ng5/os/main/.zshenv >"$HOME"/.zshenv
    curl -s https://raw.githubusercontent.com/ng5/os/main/.zshrc >"$HOME"/.zshrc
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" >/dev/null
    fi
    if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/fzf-tab" ]]; then
        git clone https://github.com/Aloxaf/fzf-tab "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/fzf-tab >/dev/null
    fi
    if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting >/dev/null
    fi
    if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions >/dev/null
    fi
    if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zfs-completion" ]]; then
        git clone https://github.com/luoxu34/zfs-completion.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/zfs-completion >/dev/null
    fi

}
function addUser() {
    touch ~/.hushlogin
    # Add user
    /sbin/groupadd -f systemd-journal-remote >/dev/null
    /sbin/useradd -m build >/dev/null
    /sbin/usermod -aG docker,sudo,systemd-journal,systemd-journal-remote build >/dev/null
    sed -i -e 's/.*%sudo ALL=(ALL) ALL/%sudo ALL=(ALL) NOPASSWD:ALL/g' /etc/sudoers
    sed -i -e 's/.*%wheel ALL=(ALL) ALL/%wheel ALL=(ALL) NOPASSWD:ALL/g' /etc/sudoers
    cp -r ~/.ssh /home/build/
    chown -R build:build /home/build/.ssh
    chmod -R 700 /home/build/.ssh
    touch /home/build/.hushlogin
    chown build:build /home/build/.hushlogin

    # change shell to zsh
    /sbin/usermod --shell /usr/bin/zsh build >/dev/null
    /sbin/usermod --shell /usr/bin/zsh root >/dev/null

    installZsh
    su build -c "bash -c installZsh"
    echo "addUser complete"
}

function installPackages() {
    apt update &>/dev/null
    apt upgrade &>/dev/null
    apt remove -y nano &>/dev/null
    apt install -y apt-listchanges bat certbot fd-find fzf gdb git iftop iperf3 manpages manpages-dev mlocate redis-server postgresql-client ripgrep systemd-coredump traceroute tree ufw unattended-upgrades wget wireguard xfsprogs zsh vim &>/dev/null

    # Install docker
    apt install -y ca-certificates curl gnupg lsb-release &>/dev/null
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg &>/dev/null
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list &>/dev/null
    apt update &>/dev/null
    apt-get install -y docker-ce docker-ce-cli containerd.io &>/dev/null
    /sbin/groupadd docker &>/dev/null

    # install docker-compose
    composeUrl=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -i browser_download_url | grep -i "docker-compose-Linux-x86_64\"" | cut -d '"' -f 4)
    curl -sL -o /usr/local/bin/docker-compose "$composeUrl"
    chmod +x /usr/local/bin/docker-compose

    echo "installPackages complete"
}

function setupFirewall() {
    ufw disable >/dev/null
    ufw allow 22 >/dev/null
    ufw allow from 172.17.0.0/16 >/dev/null
    ufw allow from 172.17.0.0/16 >/dev/null
    ufw allow from 172.18.0.0/16 >/dev/null
    ufw allow from 192.168.1.0/24 >/dev/null
    ufw allow from 192.168.5.0/24 >/dev/null

    # fix docker firewall problems
    sed -i -e 's/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/g' /etc/default/ufw

    if ! grep -i -q "dockerfix" /etc/ufw/before.rules; then
        echo "updating /etc/ufw/before.rules"
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
    echo "updating /etc/hosts "
    cat >/etc/docker/daemon.json <<EOL
{
	"iptables":false,
    "insecure-registries" : [ "da01:8082" ]
}
EOL
    echo "setupFirewall complete"
}

function setupNetwork() {
    echo -n "disabling PermitRootLogin "
    sed -i -e 's/.*PermitRootLogin.*/PermitRootLogin no # Auto-edited by debian_setup_minimal.sh/I' /etc/ssh/sshd_config && echo "OK" || echo "Failed"
    echo -n "disabling PasswordAuthentication "
    sed -i -e 's/.*PasswordAuthentication.*/PasswordAuthentication no # Auto-edited by debian_setup_minimal.sh/I' /etc/ssh/sshd_config && echo "OK" || echo "Failed"
    echo "updating /etc/hosts "
    if ! grep -i -q "# da hosts" /etc/hosts; then
        cat >>/etc/hosts <<EOL
# da hosts
192.168.1.100 infra infra.hz.lan
192.168.1.1 a1p a1p.hz.lan
192.168.1.2 a2p a2p.hz.lan
192.168.1.3 a3p a3p.hz.lan
192.168.1.4 a4p a4p.hz.lan
192.168.5.1 da01 da01.ln.lan
192.168.5.2 da02 da02.ln.lan
EOL
    fi
    echo "setupNetwork complete"
}

function services() {
    echo "y" | ufw enable
    echo -n "stopping redis-server: "
    systemctl stop redis-server &>/dev/null && echo "OK" || echo "Failed"
    echo -n "disabling redis-server: "
    systemctl disable redis-server &>/dev/null && echo "OK" || echo "Failed"
    echo -n "enabling docker: "
    systemctl enable docker &>/dev/null && echo "OK" || echo "Failed"
    echo -n "restarting docker: "
    systemctl restart docker &>/dev/null && echo "OK" || echo "Failed"
    echo "services complete"
}

export -f installZsh
installPackages
addUser
setupNetwork
setupFirewall
services
