#!/bin/bash

delgroup pyenv
delgroup go
rm -rf /opt/pyenv/
rm -rf /usr/local/go
rm -rf /usr/local/share/theHarvester/
rm -rf /usr/local/bin/theHarvester
rm -rf ./google-chrome-stable_current_amd64.deb*
rm -rf ./theHarvester
rm -rf ./Cyberia_OS
rm -rf ./go*linux-amd64.tar.gz
rm -rf ~/.theHarvester/
rm -rf /usr/local/share/SecLists/
rm -rf ./ZAP_*_unix.sh
rm -rf ./jdk-*_linux-x64_bin.tar.gz
rm -rf /opt/java
rm -rf ./ZAP_*_Linux.tar.gz
rm -rf /usr/local/share/zap/
rm -rf /usr/local/bin/zap
rm -rf /usr/local/share/burpsuite/
rm -rf /usr/local/bin/burpsuite
rm -rf ./nikto.tar.gz
rm -rf /usr/local/share/nikto/
rm -rf /usr/local/bin/nikto
rm -rf ./urlcrazy.tar.gz
rm -rf /usr/local/share/urlcrazy/
rm -rf /usr/local/bin/urlcrazy
rm -rf /usr/local/share/gophish/
rm -rf /usr/local/bin/gophish
rm -rf ./gophish.zip
rm -rf /usr/local/share/spiderfoot/
rm -rf /usr/local/bin/spiderfoot
rm -rf ./spiderfoot.tar.gz
rm -rf /usr/local/share/setoolkit/
rm -rf /usr/local/bin/setoolkit
rm -rf /usr/local/bin/ghidra 
rm -rf /usr/local/share/ghidra/
rm -rf ./ghidra.zip
rm -rf ./vscode.deb

echo '
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes users private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes users private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi' > /etc/skel/.profile
cat /etc/skel/.profile > /root/.profile
for user in $( ls /home );do
	cat /etc/skel/.profile > /home/$user/.profile
done

