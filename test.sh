#!/bin/bash

# Ubuntu 22.04.5 Post Install Script v0.1

set -e

LOGFILE="/var/log/postinstall.log"

exec > >(tee -a "$LOGFILE")
exec 2>&1

if [[ $EUID -ne 0 ]]; then
echo "Bitte als root oder mit sudo starten."
exit 1
fi

echo "=================================================="
echo " Ubuntu 22.04.5 Post Install Assistent"
echo "=================================================="

apt update
apt full-upgrade -y
apt autoremove -y
apt autoclean -y

timedatectl set-timezone Europe/Berlin

apt install -y 
whiptail 
curl 
wget 
unzip 
htop 
btop 
mc 
net-tools 
software-properties-common 
apt-transport-https 
ca-certificates 
gnupg 
lsb-release

# Hostname

if whiptail --yesno "Hostname ändern?" 10 60; then
NEW_HOSTNAME=$(whiptail --inputbox "Neuer Hostname:" 10 60 3>&1 1>&2 2>&3)

```
if [[ -n "$NEW_HOSTNAME" ]]; then
    hostnamectl set-hostname "$NEW_HOSTNAME"

    if grep -q "127.0.1.1" /etc/hosts; then
        sed -i "s/^127.0.1.1.*/127.0.1.1\t$NEW_HOSTNAME/" /etc/hosts
    else
        echo -e "127.0.1.1\t$NEW_HOSTNAME" >> /etc/hosts
    fi
fi
```

fi

# Passwort

if whiptail --yesno "Passwort des aktuellen Benutzers ändern?" 10 60; then
CURRENT_USER=${SUDO_USER:-$USER}
passwd "$CURRENT_USER"
fi

# OpenSSH prüfen

if dpkg -s openssh-server >/dev/null 2>&1; then
echo "OpenSSH Server bereits installiert."
else
if whiptail --yesno "OpenSSH Server installieren?" 10 60; then
apt install -y openssh-server
systemctl enable ssh
systemctl start ssh
fi
fi

CHOICES=$(whiptail 
--title "Paketauswahl" 
--checklist "Bitte auswählen:" 25 80 18 
"DESKTOP" "Ubuntu Desktop Minimal" OFF 
"TERMINATOR" "Terminator" OFF 
"BRAVE" "Brave Browser" OFF 
"THUNDERBIRD" "Thunderbird" OFF 
"ONLYOFFICE" "OnlyOffice" OFF 
"DOUBLECMD" "Double Commander" OFF 
"BITWARDEN" "Bitwarden Desktop" OFF 
"BWCLI" "Bitwarden CLI" OFF 
"VBOX" "VirtualBox" OFF 
"MOUSEPAD" "Mousepad Editor" OFF 
"RUSTDESK" "RustDesk" OFF 
"ABB" "Synology ABB Agent" OFF 
"DOCKER" "Docker" OFF 
"TAILSCALE" "Tailscale" OFF 
"REMMINA" "Remmina" OFF 
"UFW" "UFW Firewall" OFF 
"FAIL2BAN" "Fail2Ban" OFF 
"VLC" "VLC" OFF 
3>&1 1>&2 2>&3)

for CHOICE in $CHOICES
do
case $(echo $CHOICE | tr -d '"') in

```
    DESKTOP)
        apt install -y ubuntu-desktop-minimal
    ;;

    TERMINATOR)
        apt install -y terminator
    ;;

    THUNDERBIRD)
        apt install -y thunderbird
    ;;

    DOUBLECMD)
        apt install -y doublecmd-gtk
    ;;

    MOUSEPAD)
        apt install -y mousepad
    ;;

    REMMINA)
        apt install -y remmina
    ;;

    VLC)
        apt install -y vlc
    ;;

    UFW)
        apt install -y ufw
        ufw allow ssh
        ufw --force enable
    ;;

    FAIL2BAN)
        apt install -y fail2ban
        systemctl enable fail2ban
        systemctl start fail2ban
    ;;

    DOCKER)
        curl -fsSL https://get.docker.com | sh
    ;;

    TAILSCALE)
        curl -fsSL https://tailscale.com/install.sh | sh
    ;;

    VBOX)
        apt install -y virtualbox
    ;;

    BRAVE)
        curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
        https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

        echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" \
        > /etc/apt/sources.list.d/brave-browser-release.list

        apt update
        apt install -y brave-browser

        if command -v xdg-settings >/dev/null 2>&1; then
            xdg-settings set default-web-browser brave-browser.desktop || true
        fi
    ;;

    ONLYOFFICE)
        mkdir -p -m 700 ~/.gnupg

        curl -fsSL https://download.onlyoffice.com/GPG-KEY-ONLYOFFICE \
        | gpg --dearmor -o /usr/share/keyrings/onlyoffice.gpg

        echo "deb [signed-by=/usr/share/keyrings/onlyoffice.gpg] https://download.onlyoffice.com/repo/debian squeeze main" \
        > /etc/apt/sources.list.d/onlyoffice.list

        apt update
        apt install -y onlyoffice-desktopeditors
    ;;

    BITWARDEN)
        wget -O /tmp/bitwarden.deb \
        https://vault.bitwarden.com/download/?app=desktop&platform=linux

        apt install -y /tmp/bitwarden.deb || apt -f install -y
    ;;

    BWCLI)
        npm install -g @bitwarden/cli
    ;;

    RUSTDESK)
        wget -O /tmp/rustdesk.deb \
        https://github.com/rustdesk/rustdesk/releases/latest/download/rustdesk-1.4.1-x86_64.deb

        apt install -y /tmp/rustdesk.deb || apt -f install -y
    ;;

    ABB)
        cd /tmp

        wget -O abb.zip \
        "https://archive.synology.com/download/Utility/ActiveBackupBusinessAgent/3.2.0-5053/Synology%20Active%20Backup%20for%20Business%20Agent-3.2.0-5053-x64-deb.zip"

        unzip -o abb.zip

        chmod +x install.run

        ./install.run || true
    ;;

esac
```

done

echo
echo "=================================================="
echo "Installation abgeschlossen."
echo "Logfile: $LOGFILE"
echo "=================================================="

if whiptail --yesno "Neustart durchführen?" 10 60; then
reboot
fi
