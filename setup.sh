#!/bin/bash

set -e

# Properties

OS_NAME="Cyberia"

# Update

apt update

# Install GUI

apt install -y \
	lxqt-core \
	lightdm \
	pcmanfm-qt 

# Install common utils

apt install -y \
	firefox-esr \
	terminator \
	tree \
	sudo \
	vim \
	git \
	bash-completion

# Install Google Chrome

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

apt --fix-broken install -y ./google-chrome-stable_current_amd64.deb

# Install network utils

apt install -y \
	ipcalc \
	netcat-openbsd \
	ncat \
	telnet \
	nmap \
	wget \
	curl \
	net-tools \
	bind9-dnsutils \
	tcpdump \
	wireshark \
	tor

# Install dev utils

apt install -y \
	build-essential \
	manpages-dev

# Install hacking tools

apt install -y \
	exiftool \
	lynx

# Clone repository

git clone https://github.com/Kyoto-01/Cyberia_OS.git

# Configure groups

for user in $( ls /home );do
	usermod -aG sudo $user
	usermod -aG wireshark $user
done

# Configure Theme

for user in $( ls /home );do
	cp ./Cyberia_OS/config/lxqt/lxqt.conf /home/$user/.config/lxqt/
	cp ./Cyberia_OS/config/lxqt/panel.conf /home/$user/.config/lxqt/
done

# Configure wallpaper

mkdir -p /etc/skel/.config/pcmanfm-qt/lxqt/

cp ./Cyberia_OS/images/wallpaper.png /usr/share/images/desktop-base/${OS_NAME}_wallpaper.png

cp ./Cyberia_OS/config/pcmanfm-qt/settings.conf /etc/skel/.config/pcmanfm-qt/lxqt/

for user in $( ls /home );do
	cp ./Cyberia_OS/config/pcmanfm-qt/settings.conf /home/$user/.config/pcmanfm-qt/lxqt/
done

# Delete temporary files

rm -rf \
	Cyberia_OS/ \
	google-chrome-stable_current_amd64.deb

# Reboot

reboot
