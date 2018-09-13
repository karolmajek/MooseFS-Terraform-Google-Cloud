apt update
apt upgrade -y

wget -O - https://ppa.moosefs.com/moosefs.key | apt-key add -

echo "deb http://ppa.moosefs.com/moosefs-3/apt/$(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release)/$(lsb_release -sc) $(lsb_release -sc) main" > /etc/apt/sources.list.d/moosefs.list

apt update
apt install moosefs-master moosefs-cgi moosefs-cgiserv moosefs-cli -y

systemctl enable moosefs-cgiserv
systemctl start moosefs-cgiserv
