
## DO NOT RUN ##

## Backup
    # Remove Cloudflare API Token from caddy.container
    # Remove Immich DB Password from immich-db.container and immich.container

## Install
    # Mason Perdue
    # masonp
    # server
    # masonperdue.com
    # Root on SSD, /home on HDD
    # Set static IP and 1.1.1.3 DNS by router

## Headful boot
    sudo apt update
    sudo apt upgrade -y
    sudo apt autoremove --purge -y
    sudo apt autoclean
    sudo apt install -y openssh-server
    sudo shutdown now

## Headless Boot
    ssh -A masonp@192.168.50.10
    mkdir ~/.ssh
    nano ~/.ssh/authorized_keys
        # Paste public key
    chmod 600 ~/.ssh/authorized_keys
    sudoedit /etc/ssh/sshd_config
        # change to "Port 7583"
        # change to "PermitRootLogin no"
        # change to "PubkeyAuthentication yes"
        # change to "AuthorizedKeysFile .ssh/authorized_keys"
        # change to "PasswordAuthentication no"
        # change to "X11Forwarding no"
        # add "AllowUsers masonp"
    sudo reboot now
    rm ~/.ssh/known_hosts*
    nvim ~/.ssh/config
    # Host server
      # HostName 192.168.50.10
      # User masonp
      # Port 7583
    ssh -A server
    sudo rm /etc/motd
    sudo apt install -y git tree sane-utils nmap dnsutils imagemagick neovim curl
    nvim ~/.ssh/id_ed25519-GitHub.pub
    chmod 600 ~/.ssh/id_ed25519-GitHub.pub
    git config --global user.name masonperdue
    git config --global user.email 220426478+masonperdue@users.noreply.github.com
    git config --global core.editor nvim
    git config --global init.defaultBranch main
    git config --global commit.gpgSign true
    git config --global tag.gpgSign true
    git config --global gpg.format ssh
    git config --global user.signingkey ~/.ssh/id_ed25519-GitHub.pub
    sudo usermod -aG scanner masonp

## BASH
	cd
	git clone git@github.com:masonperdue/home-server-config.git
	echo "" >> ~/.bashrc
	echo ". /home/masonp/home-server-config/bashrc" >> ~/.bashrc
    
## Neovim
    cd
    gitClone neovim-config
    cd neovim-config
    ./setup.sh

## Blocky & Unbound
    sudo systemctl disable --now avahi-daemon.{service,socket}
    sudo systemctl mask avahi-daemon.{service,socket}
	sudo ss -tuln
	sudo apt install -y podman
	echo "net.ipv4.ip_unprivileged_port_start=53" | sudo tee /etc/sysctl.d/99-rootless-dns.conf
	sudo sysctl --system
	sudo loginctl enable-linger masonp
	mkdir ~/.config/{containers/systemd,blocky/cache,systemd/user}
    ln -sf /home/masonp/home-server-config/blocky/* /home/masonp/.config/blocky/*
    ln -sf /home/masonp/home-server-config/containers-systemd /home/masonp/.config/containers/systemd
    ln -sf /home/masonp/home-server-config/systemd-user/* /home/masonp/.config/systemd/user/*
	systemctl --user daemon-reload
	systemctl --user enable --now podman-auto-update.timer
    systemctl --user enable --now podman-image-prune.timer
    systemctl --user enable --now unbound-rebuild.timer
	systemctl --user start unbound.service blocky.service
    # Testing
        systemctl --user status unbound.service
        systemctl --user status blocky.service
        podman container list
        ss -tuln
        podman logs unbound
        podman logs -f blocky
        dig @127.0.0.1 -p 5335 google.com +short
        dig @127.0.0.1 google.com +short
        dig @127.0.0.1 -p 5335 doubleclick.net +short
        dig @127.0.0.1 doubleclick.net +short
        dig @127.0.0.1 -p 5335 cloudflare.com +dnssec
        dig @127.0.0.1 cloudflare.com +dnssec
        dig @127.0.0.1 -p 5335 dnssec-failed.org
        dig @127.0.0.1 dnssec-failed.org
        dig @127.0.0.1 -p 5335 dnssec-failed.org +cd
        dig @127.0.0.1 dnssec-failed.org +cd
		dig @127.0.0.1 www.google.com
		dig @127.0.0.1 www.youtube.com
		dig @127.0.0.1 dns.google
		dig @127.0.0.1 use-application-dns.net
	sudoedit /etc/systemd/journald.conf
		# SystemMaxUse=200M
	sudo systemctl restart systemd-journald
    sudo reboot now

## Caddy
    mkdir ~/.volumes/caddy/{site,data,config}
    ln -sf ~/home-server-config/Caddyfile ~/.volumes/caddy/Caddyfile
    printf '%s' 'YOUR_TOKEN' | podman secret create cloudflare_api_token -
    systemctl --user daemon-reload
    systemctl --user start caddy.service
    # podman exec -it caddy caddy reload --config /etc/caddy/Caddyfile

## Immich
    mkdir ~/.volumes/immich/{photos,immich-ml-cache,immich-db-data,immich-redis-data}
    printf '%s' 'YOUR_PW' | podman secret create immich_db_pw -
    systemctl --user daemon-reload
    systemctl --user start immich-server.service
    # systemctl --user status immich-server.service
    # http://192.168.50.10:2283
    # Install Immich TV (Unofficial) by GJ Compagner from Play Store on TV
    # Get API Key from Immich website to sign into to TV app
    # Turn on developer options and wireless debugging on Google TV
    # sudo apt install -y adb
    # adb connect YOUR_TV_IP_ADDRESS
    # adb shell settings put secure screensaver_components nl.giejay.android.tv.immich/.screensaver.ScreenSaverService
    # adb shell settings put secure screensaver_enabled 1
    # adb shell settings put system screen_off_timeout 60000
    # adb shell settings get secure screensaver_components
    # adb shell dumpsys deviceidle whitelist +nl.giejay.android.tv.immich
    # adb shell cmd appops set nl.giejay.android.tv.immich RUN_IN_BACKGROUND allow

## Firewalld
    sudo apt install -y firewalld
    sudo systemctl status firewalld.service
    sudo firewall-cmd --set-default-zone drop
    sudo firewall-cmd --zone=drop --add-port=7583/tcp --add-port=53/tcp --add-port=53/udp --add-port=80/tcp --add-port=443/tcp
    sudo firewall-cmd --runtime-to-permanent
    # Testing
        sudo firewall-cmd --state
        sudo firewall-cmd --get-default-zone
        sudo firewall-cmd --get-active-zones
        sudo firewall-cmd --list-all
