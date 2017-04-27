#!/bin/bash

# update repo
apt-get update -y

# install htop
apt-get install -y htop

# check dependencies installation
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# get docker gpg key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# add repository
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# update repo
apt-get update -y

# install docker
apt-get install -y docker-ce

# allow ubuntu user to use docker without sudoing
sudo groupadd docker
sudo usermod -aG docker ubuntu

# check install
docker run hello-world > /home/ubuntu/docker-status.log

# clone mastodon
cd /home/ubuntu
su - ubuntu -c 'git clone https://github.com/tootsuite/mastodon.git'

mkdir -p /data
mkdir -p /var/lib/postgresql/data

sudo chown ubuntu. /data
sudo chown ubuntu. /var/lib/postgresql
sudo chown ubuntu. /var/lib/postgresql/data

# install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.12.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo 'Setup done.' > /home/ubuntu/status.log
