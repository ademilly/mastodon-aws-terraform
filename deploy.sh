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

cd mastodon && cp .env.production.sample .env.production

docker-compose run --rm web rake secret

sed -i -e 's/LOCAL_DOMAIN=example.com/LOCAL_DOMAIN=${local_domain}/g' .env.production
sed -i -e 's/LOCAL_HTTPS=true/LOCAL_HTTPS=false/g' .env.production

sed -i -e 's/SMTP_SERVER=smtp.mailgun.org/SMTP_SERVER=${smtp_server}/g' .env.production
sed -i -e 's/SMTP_LOGIN=/SMTP_LOGIN=${smtp_login}/g' .env.production
sed -i -e 's/SMTP_PASSWORD=/SMTP_PASSWORD=${smtp_password}/g' .env.production
sed -i -e 's/SMTP_FROM_ADDRESS=/SMTP_FROM_ADDRESS=${smtp_from_address}/g' .env.production

sed -i -e "s/PAPERCLIP_SECRET=/PAPERCLIP_SECRET=$(docker-compose run --rm web rake secret)/g" .env.production
sed -i -e "s/SECRET_KEY_BASE=/SECRET_KEY_BASE=$(docker-compose run --rm web rake secret)/g" .env.production
sed -i -e "s/OTP_SECRET=/OTP_SECRET=$(docker-compose run --rm web rake secret)/g" .env.production

sed -i -e 's/#    volumes:/    volumes:/g' docker-compose.yml
sed -i -e 's;#      - ./postgres:/var/lib/postgresql/data;      - ./postgres:/var/lib/postgresql/data;g' docker-compose.yml
sed -i -e 's;#      - ./redis:/data;      - ./redis:/data;g' docker-compose.yml
sed -i -e 's/      - "3000:3000"/      - "80:3000"/g' docker-compose.yml

docker-compose run --rm web rake db:migrate
docker-compose run --rm web rake assets:precompile
docker-compose up -d

echo 'Deploy done.' >> /home/ubuntu/status.log
