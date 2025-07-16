#!/bin/bash

delgroup pyenv
delgroup go
rm -rf /opt/pyenv
rm -rf /usr/local/go
rm -rf /usr/local/share/theHarvester
rm -f /usr/local/bin/theHarvester
rm -f ./google-chrome-stable_current_amd64.deb*
rm -rf ./theHarvester
rm -rf ./Cyberia_OS
rm -f ./go*linux-amd64.tar.gz
rm -rf ~/.theHarvester/

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

