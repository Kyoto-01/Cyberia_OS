#!/bin/bash

set -e

# Properties

OS_NAME="Cyberia"

# Directories

GUI_SYS_CONFIG_DIR=/etc/skel/.config/pcmanfm-qt/lxqt/
GUI_USR_CONFIG_DIR=.config/pcmanfm-qt/lxqt/
GUI_REP_CONFIG_DIR=./
WALLPAPERS_DIR=/usr/share/images/desktop-base/

# Files

GUI_SYS_CONFIG_FILE=${GUI_SYS_CONFIG_DIR}/settings.conf
GUI_USR_CONFIG_FILE=${GUI_USR_CONFIG_DIR}/settings.conf
GUI_REP_CONFIG_FILE=${GUI_REP_CONFIG_DIR}/lxqt_settings.conf
MAIN_WALLPAPER_FILE=${WALLPAPERS_DIR}/${OS_NAME}_wallpaper.png

# Update

apt update --fix-broken

# Install GUI

apt install -y \
	lxqt-core \
	lightdm \
	pcmanfm-qt 

mkdir -p $GUI_SYS_CONFIG_DIR

# Install common utils

apt install -y \
	firefox-esr \
	terminator \
	sudo \
	vim \
	git \
	bash-completion

# Install Google Chrome

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

apt --fix-broken install -y ./google-chrome-stable_current_amd64.deb

rm -f google-chrome-stable_current_amd64.deb

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

# Configure groups

for user in $( ls /home );do
	usermod -aG sudo $user
	usermod -aG wireshark $user
done

# Configure wallpaper

cp wallpaper.png $MAIN_WALLPAPER_FILE

cp $GUI_REP_CONFIG_FILE $GUI_SYS_CONFIG_FILE

for user in $( ls /home );do
	cp $GUI_REP_CONFIG_FILE /home/$user/$GUI_USR_CONFIG_FILE
done

# Reboot

reboot
