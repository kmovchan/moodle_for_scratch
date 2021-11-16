#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

sudo add-apt-repository -y ppa:gluster/glusterfs-7
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo apt-get install -y glusterfs-server nfs-ganesha-gluster python collectd
DEVICE=/dev/$(lsblk -n | awk '$NF != "/" {print $1}' | tail -1)
#FS_TYPE=$(file -s $DEVICE | awk '{print $2}')
# If no FS, then this output contains "data"
#if [ "$FS_TYPE" = "data" ]
#then
#    mkfs -t ext4 $DEVICE
#fi
##mkfs -t xfs /dev/nvme1n1
##
##mount /dev/nvme1n1 /glusterfs
##echo "/dev/nvme1n1 xfs defaults 0 0"  >> /etc/fstab
##mkdir -p /glusterfs/replica

mkfs -t xfs $DEVICE
mkdir  /glusterfs

mount $DEVICE /glusterfs
echo "$DEVICE xfs defaults 0 0"  >> /etc/fstab

mkdir -p /glusterfs/replica