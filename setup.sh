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
	man-db \
	acl \
	wget \
	curl

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
	net-tools \
	bind9-dnsutils \
	tcpdump \
	wireshark \
	tor

# Install dev utils

apt install -y \
	python3.11-venv \
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

mkdir /opt/pyenv/shims /opt/pyenv/versions/
chmod -R g+rw /opt/pyenv/shims /opt/pyenv/versions/
setfacl -d -m g:pyenv:rw /opt/pyenv/shims
setfacl -d -m g:pyenv:rw /opt/pyenv/versions/

export PYENV_ROOT="/opt/pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv install 3.12.4

# Install Golang

addgroup go
usermod -aG go root

mkdir -p /usr/local/go/packages /usr/local/go/bin
chown -R root:go /usr/local/go
chmod -R g+s /usr/local/go
chmod -R g+rwx /usr/local/go/packages /usr/local/go/bin
setfacl -d -m g:go:rwx /usr/local/go/packages
setfacl -d -m g:go:rwx /usr/local/go/bin

wget https://go.dev/dl/go1.24.5.linux-amd64.tar.gz
tar -C /usr/local/ -xvzf go1.24.5.linux-amd64.tar.gz

export GOBIN=/usr/local/go/bin
export GOPATH=/usr/local/go/packages
export PATH=$PATH:$GOBIN

# Install JDK

mkdir -p /opt/java/

wget https://download.oracle.com/java/24/latest/jdk-24_linux-x64_bin.tar.gz

tar -xvzf jdk-24_linux-x64_bin.tar.gz -C /opt/java

export JAVA_HOME=/opt/java/jdk-24.0.2
export PATH=$JAVA_HOME/bin:$PATH

# Install hacking tools

apt install -y \
	exiftool \
	lynx \
	wafw00f \
	sqlmap \
	john

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

# Install ffuf

go install github.com/ffuf/ffuf/v2@latest

# Install Burp Suite

mkdir -p /usr/local/share/burpsuite/

wget "https://portswigger-cdn.net/burp/releases/download?product=community&version=2025.6.4&type=Jar" -O /usr/local/share/burpsuite/burpsuite_community_linux_v2025_6_4.jar

echo -e "#!/bin/bash\n/opt/java/jdk-24.0.2/bin/java -jar /usr/local/share/burpsuite/burpsuite_community_linux_v2025_6_4.jar" > /usr/local/share/burpsuite/burpsuite

chmod +x /usr/local/share/burpsuite/burpsuite

ln -s /usr/local/share/burpsuite/burpsuite /usr/local/bin/burpsuite

# Install OWASP ZAP

wget https://github.com/zaproxy/zaproxy/releases/download/v2.16.1/ZAP_2.16.1_Linux.tar.gz

mkdir -p /usr/local/share/zap/

tar -xvzf ZAP_2.16.1_Linux.tar.gz -C /usr/local/share/zap/

echo -e "#!/bin/bash\n/opt/java/jdk-24.0.2/bin/java -jar /usr/local/share/zap/ZAP_2.16.1/zap-2.16.1.jar" > /usr/local/share/zap/zap

chmod +x /usr/local/share/zap/zap

ln -s /usr/local/share/zap/zap /usr/local/bin/zap

# Install Nikto

mkdir -p /usr/local/share/nikto/

wget https://github.com/sullo/nikto/archive/refs/tags/2.5.0.tar.gz -O nikto.tar.gz

tar -xvzf nikto.tar.gz --strip-components=1 -C /usr/local/share/nikto/

ln -s /usr/local/share/nikto/program/nikto.pl /usr/local/bin/nikto

# Install SecLists

git clone https://github.com/danielmiessler/SecLists.git

mv ./SecLists /usr/local/share/

# Configure groups

echo 'EXTRA_GROUPS="users sudo wireshark pyenv"' >> /etc/adduser.conf
echo 'ADD_EXTRA_GROUPS=1' >> /etc/adduser.conf

for user in $( ls /home );do
	usermod -aG sudo $user
	usermod -aG wireshark $user
	usermod -aG pyenv $user
done

# Configure Theme

mkdir -p /etc/skel/.config/lxqt/
cp ./Cyberia_OS/config/lxqt/lxqt.conf /etc/skel/.config/lxqt/
cp ./Cyberia_OS/config/lxqt/panel.conf /etc/skel/.config/lxqt/
cp ./Cyberia_OS/config/lxqt/session.conf /etc/skel/.config/lxqt/

mkdir -p /root/.config/lxqt/
cp ./Cyberia_OS/config/lxqt/lxqt.conf /root/.config/lxqt/
cp ./Cyberia_OS/config/lxqt/panel.conf /root/.config/lxqt/
cp ./Cyberia_OS/config/lxqt/session.conf /root/.config/lxqt/

for user in $( ls /home );do
	mkdir -p /home/$user/.config/lxqt/
	cp ./Cyberia_OS/config/lxqt/lxqt.conf /home/$user/.config/lxqt/
	cp ./Cyberia_OS/config/lxqt/panel.conf /home/$user/.config/lxqt/
	cp ./Cyberia_OS/config/lxqt/session.conf /home/$user/.config/lxqt/
done

# Configure wallpaper

mkdir -p /etc/skel/.config/pcmanfm-qt/lxqt/
mkdir -p /root/.config/pcmanfm-qt/lxqt/

cp ./Cyberia_OS/images/wallpaper.png /usr/share/images/desktop-base/${OS_NAME}_wallpaper.png

cp ./Cyberia_OS/config/pcmanfm-qt/settings.conf /etc/skel/.config/pcmanfm-qt/lxqt/

cp ./Cyberia_OS/config/pcmanfm-qt/settings.conf /root/.config/pcmanfm-qt/lxqt/

for user in $( ls /home );do
	mkdir -p /home/$user/.config/pcmanfm-qt/lxqt/
	cp ./Cyberia_OS/config/pcmanfm-qt/settings.conf /home/$user/.config/pcmanfm-qt/lxqt/
done

# Create Shortcuts

rm -rf \
	/usr/share/applications/google-chrome.desktop \
	/usr/share/applications/firefox-esr.desktop

cp ./Cyberia_OS/shortcuts/*.desktop /usr/share/applications/

mkdir -p /root/Desktop/
cp ./Cyberia_OS/shortcuts/*.desktop /root/Desktop/

for user in $( ls /home );do
	mkdir -p /home/$user/Desktop/
	cp ./Cyberia_OS/shortcuts/*.desktop /home/$user/Desktop/
	chown $user:$user /home/$user/Desktop/*.desktop
done

# Delete temporary files

rm -rf \
	./Cyberia_OS/ \
	./google-chrome-stable_current_amd64.deb \
	./go*linux-amd64.tar.gz \
	./ZAP_*_unix.sh \
	./jdk-*_linux-x64_bin.tar.gz \
	./ZAP_*_Linux.tar.gz \
	./nikto.tar.gz

# Reboot

reboot
