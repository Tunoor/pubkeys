#!/bin/bash -xe
# user-data script to grant ssh access to users via authorized keys

# log output from this user-data script to /var/log/user-data.log
#AUTHORIZED_KEYS_URL=https://gist.githubusercontent.com/nonbeing/5ea084ba44ecbf619d6a9563835c99c6/raw/3ba57ef435f9e4d6972aa6e5e9db996eaf8b3f06/cc_authorized_keys
AUTHORIZED_KEYS_URL="https://raw.githubusercontent.com/cldcvr/pubkeys/master/hooq/hooq-authorized_keys"


exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# create 'hooq-user' and give sudo privileges
sudo adduser hooq-user --gecos "CloudCover DefaultUser,1,1,1"  --disabled-password
echo "hooq-user:Hooq123" | sudo chpasswd

sudo adduser hooq-user sudo
sudo adduser hooq-user admin
sudo adduser hooq-user root

# not required, but just a safeguard
sudo mkdir -p /home/hooq-user/.ssh

# add authorized_keys for hooq-user
sudo curl --silent ${AUTHORIZED_KEYS_URL} -o /home/hooq-user/.ssh/authorized_keys

# add authorized_keys for ubuntu
sudo curl --silent ${AUTHORIZED_KEYS_URL} >> /home/ubuntu/.ssh/authorized_keys

# since user-data runs as root, fix permissions:
sudo chmod a+r /home/hooq-user/.ssh/authorized_keys
sudo chmod a+r /home/ubuntu/.ssh/authorized_keys
sudo chown -R hooq-user:hooq-user /home/hooq-user/
sudo chown -R ubuntu:ubuntu /home/ubuntu/
