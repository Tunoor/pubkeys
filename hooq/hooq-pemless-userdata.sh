#!/bin/bash -xe
# user-data script to grant ssh access to users via authorized keys

# log output from this user-data script to /var/log/user-data.log
#AUTHORIZED_KEYS_URL=https://gist.githubusercontent.com/nonbeing/5ea084ba44ecbf619d6a9563835c99c6/raw/3ba57ef435f9e4d6972aa6e5e9db996eaf8b3f06/cc_authorized_keys
AUTHORIZED_KEYS_URL="https://raw.githubusercontent.com/cldcvr/pubkeys/master/hooq/authorized_keys"


exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# create 'hooq-user' and give sudo privileges
sudo adduser hooq-user --gecos "CloudCover DefaultUser,1,1,1"  --disabled-password
echo "hooq-user:CCover123" | sudo chpasswd

sudo adduser hooq-user sudo
sudo adduser hooq-user admin
sudo adduser hooq-user root

# not required, but just a safeguard
sudo mkdir -p /home/hooq-user/.ssh

#sudo curl --silent https://s3.ap-south-1.amazonaws.com/cloudcover-devops-test/ak -o /home/hooq-user/.ssh/authorized_keys
sudo curl --silent ${AUTHORIZED_KEYS_URL} -o /home/hooq-user/.ssh/authorized_keys

# since user-data runs as root, fix permissions:
sudo chmod a+r /home/hooq-user/.ssh/authorized_keys
sudo chown -R hooq-user:hooq-user /home/hooq-user/https://raw.githubusercontent.com/cldcvr/pubkeys/master/hooq/authorized_keys
