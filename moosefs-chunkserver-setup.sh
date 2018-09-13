apt update
apt upgrade -y

parted /dev/sdb mklabel gpt
parted /dev/sdc mklabel gpt
parted /dev/sdd mklabel gpt

parted -a opt /dev/sdb mkpart primary ext4 0% 100%
parted -a opt /dev/sdc mkpart primary ext4 0% 100%
parted -a opt /dev/sdd mkpart primary ext4 0% 100%

mkfs.ext4 /dev/sdb1 -q
mkfs.ext4 /dev/sdc1 -q
mkfs.ext4 /dev/sdd1 -q

mkdir -p /mnt/sdb1
mkdir -p /mnt/sdc1
mkdir -p /mnt/sdd1

mount -o defaults /dev/sdb1 /mnt/sdb1
mount -o defaults /dev/sdc1 /mnt/sdc1
mount -o defaults /dev/sdd1 /mnt/sdd1

wget -O - https://ppa.moosefs.com/moosefs.key | apt-key add -

echo "deb http://ppa.moosefs.com/moosefs-3/apt/$(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release)/$(lsb_release -sc) $(lsb_release -sc) main" > /etc/apt/sources.list.d/moosefs.list

apt update
apt install moosefs-chunkserver -y

chown -R mfs:mfs /mnt/sdb1
chown -R mfs:mfs /mnt/sdc1
chown -R mfs:mfs /mnt/sdd1

echo "/mnt/sdb1 -5GiB" >> /etc/mfs/mfshdd.cfg
echo "/mnt/sdc1 -5GiB" >> /etc/mfs/mfshdd.cfg
echo "/mnt/sdd1 -5GiB" >> /etc/mfs/mfshdd.cfg

systemctl enable moosefs-chunkserver
systemctl start moosefs-chunkserver
