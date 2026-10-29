
## DO NOT RUN ##

## Install
    # Mason Perdue
    # mason
    # server
    # home.masonerdue.com
	# install openssh
    # Set static IP 192.168.50.2 and 1.1.1.3 DNS by router

## Debian
	ssh -A mason@192.168.50.2
	sudo apt update
    sudo apt upgrade -y
    sudo apt autoremove --purge -y
    sudo apt autoclean
    # mkdir ~/.ssh
    nano ~/.ssh/authorized_keys
        Paste public key
    chmod 600 ~/.ssh/authorized_keys
    sudoedit /etc/ssh/sshd_config
        # change to "Port 7583"
        # change to "PermitRootLogin no"
        # change to "PubkeyAuthentication yes"
        # change to "AuthorizedKeysFile .ssh/authorized_keys"
        # change to "PasswordAuthentication no"
        # change to "X11Forwarding no"
        # add "AllowUsers mason"
    sudo reboot now
    rm ~/.ssh/known_hosts*
    nvim ~/.ssh/config
	    # Host server
	      # HostName 192.168.50.2
	      # User mason
	      # Port 7583
    ssh -A server
    sudo rm /etc/motd
    sudo apt install -y git dnsutils htop
	git clone https://github.com/masonerdue/neovim-config.git
	./neovim-config/setup.sh
    nvim ~/.ssh/id_ed25519-GitHub.pub
    chmod 600 ~/.ssh/id_ed25519-GitHub.pub
	

## Git
	cd
	git clone git@github.com:masonerdue/home-server-config.git
	ln -sf /home/mason/home-server-config/gitconfig /home/mason/.gitconfig
    
## Neovim
    cd
    gitClone neovim-config
    cd neovim-config
    ./setup.sh

## Unbound
	sudo apt install -y unbound
	sudo ln -sf /home/mason/home-server-config/unbound.conf /etc/unbound/unbound.conf.d/local.conf
	sudo systemctl restart unbound.service
	sudo systemctl status unbound.service

## Blocky
    sudo systemctl disable --now avahi-daemon.{service,socket}
    sudo systemctl mask avahi-daemon.{service,socket}
	sudo ss -tuln
	sudo apt install -y podman
	echo "net.ipv4.ip_unprivileged_port_start=53" | sudo tee /etc/sysctl.d/99-rootless-dns.conf
	sudo sysctl --system
	sudo loginctl enable-linger mason
	mkdir -p {~/blocky-cache,~/.config/{containers/systemd,systemd/user}}
    ln -sf /home/mason/home-server-config/containers-systemd/* /home/mason/.config/containers/systemd/
    ln -sf /home/mason/home-server-config/systemd-user/* /home/mason/.config/systemd/user/
	systemctl --user daemon-reload
	systemctl --user enable --now podman-auto-update.timer
    systemctl --user enable --now podman-image-prune.timer
	systemctl --user start blocky.service
    # Testing
        systemctl --user status blocky.service
        podman container list
        ss -tuln
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

# Firewalld
    sudo apt install -y firewalld
    sudo systemctl status firewalld.service
    sudo firewall-cmd --set-default-zone drop
    sudo firewall-cmd --zone=drop --add-port=7583/tcp --add-port=53/tcp --add-port=53/udp
    sudo firewall-cmd --runtime-to-permanent
    Testing
        sudo firewall-cmd --state
        sudo firewall-cmd --get-default-zone
        sudo firewall-cmd --get-active-zones
        sudo firewall-cmd --list-all
