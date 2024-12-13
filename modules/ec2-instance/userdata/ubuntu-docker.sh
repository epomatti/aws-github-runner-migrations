#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

apt update
apt upgrade -y


###########################
### Docker Installation ###
###########################

# Add Docker's official GPG key:
apt-get install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

# Install the Docker packages
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


#################
### Data disk ###
#################

# Variables
drive="/dev/nvme1n1"
mount_point="/mnt/data"

# Mount the disk
mkdir -p $mount_point
mkfs.ext4 $drive
mount $drive $mount_point
# chown ubuntu:ubuntu /mnt/ebs-volume
echo "$drive $mount_point  ext4  defaults,nofail  0  2" | tee -a /etc/fstab

#####################
### Docker config ###
#####################

daemonjsonpath="/etc/docker/daemon.json"
daemonjson="""
{
  \"data-root\": \"/mnt/data\"
}
"""

touch $daemonjsonpath
echo $daemonjson > $daemonjsonpath


reboot
