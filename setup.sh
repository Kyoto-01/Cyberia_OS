#!/bin/bash

set -e

# Properties

OS_NAME="Cyberia"

# Directories

GUI_REP_CONFIG_DIR=./gui
PCMANFM_USR_CONFIG_DIR=.config/pcmanfm-qt/lxqt
LXQT_USR_CONFIG_DIR=.config/lxqt
WALLPAPERS_DIR=/usr/share/images/desktop-base

# Files

GUI_SYS_CONFIG_FILE=${GUI_SYS_CONFIG_DIR}/settings.conf
GUI_USR_CONFIG_FILE=${GUI_USR_CONFIG_DIR}/settings.conf
GUI_REP_CONFIG_FILE=${GUI_REP_CONFIG_DIR}/pcmanfm_settings.conf
LXQT_USR_CONFIG_FILE=${LXQT_USR_CONFIG_DIR}/lxqt.conf
LXQT_REP_CONFIG_FILE=${LXQT_REP_CONFIG_DIR}/lxqt.conf
LXQT_USR_PANEL_FILE=${LXQT_USR_CONFIG_DIR}/panel.conf
LXQT_REP_PANEL_FILE=${LXQT_REP_CONFIG_DIR}/lxqt_panel.conf
MAIN_WALLPAPER_FILE=${WALLPAPERS_DIR}/${OS_NAME}_wallpaper.png

# Update

apt update

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
	tree \
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

# Configure Themes

for user in $( ls /home );do
	cp $LXQT_REP_CONFIG_FILE /home/$user/$LXQT_USR_CONFIG_FILE
	cp $LXQT_REP_PANEL_FILE /home/$user/$LXQT_USR_PANEL_FILE
done

# Configure wallpaper

PCMANFM_LXQT_SYS_CONFIG_DIR=/etc/skel/.config/pcmanfm-qt/lxqt

cp wallpaper.png $MAIN_WALLPAPER_FILE

cp ./gui/ $GUI_SYS_CONFIG_FILE

for user in $( ls /home );do
	cp $GUI_REP_CONFIG_FILE /home/$user/$GUI_USR_CONFIG_FILE
done

# Reboot

reboot
