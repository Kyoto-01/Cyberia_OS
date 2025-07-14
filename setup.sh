#!/bin/bash

set -e

# Properties

OS_NAME="Cyberia"

# Update repositories

apt update

# Install git

apt install -y git

# Clone the project repository

git clone https://github.com/Kyoto-01/Cyberia_OS.git

# Update session config files

cp ./Cyberia_OS/config/session/*.profile /etc/profile.d/
cp ./Cyberia_OS/config/session/profile /etc/skel/.profile
cp ./Cyberia_OS/config/session/bashrc /etc/skel/.bashrc

cp ./Cyberia_OS/config/session/profile /root/.profile
cp ./Cyberia_OS/config/session/bashrc /root/.bashrc

for user in $( ls /home );do
	cp ./Cyberia_OS/config/session/profile /home/$user/.profile
	cp ./Cyberia_OS/config/session/bashrc /home/$user/.bashrc
done

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
	bash-completion \
	man-db

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
	make \
	build-essential \
	manpages-dev \
	libssl-dev \
	zlib1g-dev \
	libbz2-dev \
	libreadline-dev \
	libsqlite3-dev \
	llvm \
	libncursesw5-dev \
	xz-utils \
	tk-dev \
	libxml2-dev \
	libxmlsec1-dev \
	libffi-dev \
	liblzma-dev

# Install Pyenv

mkdir -p /opt/pyenv/
groupadd pyenv
usermod -aG pyenv root
chown root:pyenv /opt/pyenv
chmod g+s /opt/pyenv

git clone https://github.com/pyenv/pyenv.git /opt/pyenv
git clone https://github.com/pyenv/pyenv-virtualenv.git /opt/pyenv/plugins/pyenv-virtualenv

mkdir /opt/pyenv/shims
chmod -R g+w /opt/pyenv/shims

export PYENV_ROOT="/opt/pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv install 3.12.4

# Install hacking tools

apt install -y \
	exiftool \
	lynx

# Install TheHarvester

pyenv virtualenv 3.12.4 theHarvester_venv

git clone https://github.com/laramies/theHarvester.git

pyenv activate theHarvester_venv
cd ./theHarvester/
pip install .
cd ../
pyenv deactivate

mv ./theHarvester/ /usr/local/share/

echo -e '#!/bin/bash\nsource ~/.profile\npyenv activate theHarvester_venv\ncd /usr/local/share/theHarvester\n./theHarvester.py "$@"\npyenv deactivate' > /usr/local/bin/theHarvester

chmod +x /usr/local/bin/theHarvester

# Configure groups

echo 'EXTRA_GROUPS="users pyenv go"' >> /etc/adduser.conf
echo 'ADD_EXTRA_GROUPS=1' >> /etc/adduser.conf

for user in $( ls /home );do
	usermod -aG sudo $user
	usermod -aG wireshark $user
	usermod -aG pyenv $user
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

cp ./Cyberia_OS/config/pcmanfm-qt/settings.conf /root/.config/pcmanfm-qt/lxqt/

for user in $( ls /home );do
	cp ./Cyberia_OS/config/pcmanfm-qt/settings.conf /home/$user/.config/pcmanfm-qt/lxqt/
done

# Delete temporary files

rm -rf \
	Cyberia_OS/ \
	google-chrome-stable_current_amd64.deb

# Reboot

reboot
