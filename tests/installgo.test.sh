#!/bin/bash

addgroup go
usermod -aG go root

mkdir -p /usr/local/go/packages /usr/local/go/bin
chown -R root:go /usr/local/go
chmod -R g+s /usr/local/go
chmod -R g+rwx /usr/local/go/packages /usr/local/go/bin

wget https://go.dev/dl/go1.24.5.src.tar.gz
tar -C /usr/local/ -xvzf go1.24.5.src.tar.gz

echo '# Golang' >> /etc/profile
echo 'export GOBIN=/usr/local/go/bin' >> /etc/profile
echo 'export GOPATH=/usr/local/go/packages' >> /etc/profile
echo 'export PATH=$PATH:$GOBIN' >> /etc/profile

for user in $( ls /home );do
	cat /etc/profile > /home/$user/.profile
done

source /etc/profile
