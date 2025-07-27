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

# Configure main responses

## For wireshark
echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections

## For vscode
echo "packagecloud.io/microsoft/vscode vscode/accept-eula select true" | sudo debconf-set-selections

# Install GUI

apt install -y \
	lxqt-core \
	lightdm \
	pcmanfm-qt 

# Install common utils

DEBIAN_FRONTEND=noninteractive apt install -y \
	firefox-esr \
	terminator \
	tree \
	sudo \
	vim \
	bash-completion \
	man-db \
	acl \
	wget \
	curl \
	libreoffice \
	vlc \
	scrot \
	gimp \
	jq

# Install Google Chrome

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

apt --fix-broken install -y ./google-chrome-stable_current_amd64.deb

mkdir -p /etc/sked/.config/google-chrome/Default/
cp ./shortcuts/chrome/shortcuts.json /etc/sked/.config/google-chrome/Default/Bookmarks

mkdir -p /root/.config/google-chrome/Default/
cp ./shortcuts/chrome/shortcuts.json /root/.config/google-chrome/Default/Bookmarks

for user in $( ls /home );do
	mkdir -p /home/$user/.config/google-chrome/Default/
	cp ./shortcuts/chrome/shortcuts.json /home/$user/.config/google-chrome/Default/Bookmarks
done

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
	tor \
	proxychains \
	traceroute \
	tcptraceroute \
	openvpn

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

pyenv install 3.7
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

# Install ruby

apt install -y \
	ruby \
	ruby-dev

# Install Bundler

gem install bundler

# Install VSCode

wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O vscode.deb

DEBIAN_FRONTEND=noninteractive dpkg -i ./vscode.deb

# Install hacking tools

apt install -y \
	exiftool \
	lynx \
	wafw00f \
	sqlmap \
	john \
	hydra \
	whois \
	python3-scapy \
	hping3 \
	whatweb \
	aircrack-ng \
	httrack \
	recon-ng

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

# Install Gophish

wget https://github.com/gophish/gophish/releases/download/v0.12.1/gophish-v0.12.1-linux-64bit.zip -O gophish.zip

unzip gophish.zip -d /usr/local/share/gophish/

chmod +x /usr/local/share/gophish/gophish

echo -e "#!/bin/bash\ncd /usr/local/share/gophish/\n./gophish \"\$@\"" > /usr/local/bin/gophish

chmod +x /usr/local/bin/gophish

# Install Spiderfoot

source ~/.profile

mkdir -p /usr/local/share/spiderfoot/

wget https://github.com/smicallef/spiderfoot/archive/v4.0.tar.gz -O spiderfoot.tar.gz

tar zxvf spiderfoot.tar.gz -C /usr/local/share/spiderfoot/ --strip-components=1

cd /usr/local/share/spiderfoot/

chmod +x ./sf.py

pyenv virtualenv 3.7 spiderfoot_venv

pyenv activate spiderfoot_venv

pip3 install -r requirements.txt

pyenv deactivate

cd -

echo -e "#!/bin/bash\nsource ~/.profile\ncd /usr/local/share/spiderfoot/\npyenv activate spiderfoot_venv\n./sf.py \"\$@\"\npyenv deactivate" > /usr/local/bin/spiderfoot

chmod +x /usr/local/bin/spiderfoot

# Install Setoolkit

apt install -y \
	freetds-dev \
	libkrb5-dev

source ~/.profile

git clone https://github.com/trustedsec/social-engineer-toolkit.git

mv ./social-engineer-toolkit/ /usr/local/share/

mv /usr/local/share/social-engineer-toolkit/ /usr/local/share/setoolkit/

cd /usr/local/share/setoolkit/

chmod +x ./setoolkit

pyenv virtualenv 3.7 setoolkit_venv

pyenv activate setoolkit_venv

pip3 install -r requirements.txt

python setup.py

pyenv deactivate

cd -

echo -e "#!/bin/bash\nsource ~/.profile\ncd /usr/local/share/setoolkit/\npyenv activate setoolkit_venv\n./setoolkit \"\$@\"\npyenv deactivate" > /usr/local/bin/setoolkit

chmod +x /usr/local/bin/setoolkit

# Install Ghidra

wget https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.4_build/ghidra_11.4_PUBLIC_20250620.zip -O ghidra.zip

unzip ./ghidra.zip -d /usr/local/share/

mv /usr/local/share/ghidra_11.4_PUBLIC/ /usr/local/share/ghidra/

echo -e "#!/bin/bash\nsource ~/.profile\n/usr/local/share/ghidra/ghidraRun" > /usr/local/bin/ghidra

chmod +x /usr/local/bin/ghidra

# Install ffuf

go install github.com/ffuf/ffuf/v2@latest

# Install Feroxbuster

curl -sL https://raw.githubusercontent.com/epi052/feroxbuster/main/install-nix.sh | bash -s /usr/local/bin

# Install Urlcrazy

mkdir /usr/local/share/urlcrazy

wget https://github.com/urbanadventurer/urlcrazy/archive/refs/tags/v0.7.3.tar.gz -O urlcrazy.tar.gz

tar -xvzf urlcrazy.tar.gz -C /usr/local/share/urlcrazy/ --strip-components=1

cd /usr/local/share/urlcrazy/
bundle install
chmod +x urlcrazy
cd -

echo -e "#!/bin/bash\ncd /usr/local/share/urlcrazy/\n./urlcrazy \"\$@\"" > /usr/local/bin/urlcrazy

chmod +x /usr/local/bin/urlcrazy

# Install DotDotPwn

wget "https://github.com/wireghoul/dotdotpwn/archive/refs/tags/3.0.2.tar.gz" -O dotdotpwn.tar.gz

mkdir -p /usr/local/share/dotdotpwn/

tar -xvzf dotdotpwn.tar.gz -C /usr/local/share/dotdotpwn/ --strip-components=1

echo -e "#!/bin/bash\ncd /usr/local/share/dotdotpwn/\n./dotdotpwn.pl \"\$@\"" > /usr/local/bin/dotdotpwn

chmod +x /usr/local/bin/dotdotpwn

# Install XSStrike

source ~/.profile

wget "https://github.com/s0md3v/XSStrike/archive/refs/tags/3.1.6.tar.gz" -O xsstrike.tar.gz

mkdir -p /usr/local/share/xsstrike/

tar -xvzf xsstrike.tar.gz -C /usr/local/share/xsstrike/ --strip-components=1

cd /usr/local/share/xsstrike/

pyenv virtualenv 3.12 xsstrike_venv

pyenv activate xsstrike_venv

pip install -r requirements.txt --break-system-packages

pyenv deactivate

cd -

echo -e "#!/bin/bash\nsource ~/.profile\ncd /usr/local/share/xsstrike/\npyenv activate xsstrike_venv\npython xsstrike.py \"\$@\"\npyenv deactivate" > /usr/local/bin/xsstrike

chmod +x /usr/local/bin/xsstrike

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

# Install Metasploit

curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall

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

cp ./Cyberia_OS/shortcuts/desktop/*.desktop /usr/share/applications/

mkdir -p /root/Desktop/
cp ./Cyberia_OS/shortcuts/desktop/*.desktop /root/Desktop/

for user in $( ls /home );do
	mkdir -p /home/$user/Desktop/
	cp ./Cyberia_OS/shortcuts/desktop/*.desktop /home/$user/Desktop/
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
	./nikto.tar.gz \
	./msfinstall \
	./urlcrazy.tar.gz \
	./gophish.zip \
	./spiderfoot.tar.gz \
	./ghidra.zip \
	./vscode.deb \
	./dotdotpwn.tar.gz \
	./xsstrike.tar.gz

# Reboot

reboot
