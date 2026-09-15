#!/bin/bash

sudo apt update
sudo apt install openjdk-21-jdk -y
#Add the Jenkins repository key

#Install growpart
apt install -y cloud-guest-utils

growpart /dev/nvme0n1 1
resize2fs /dev/nvme0n1p1

#jenkins gpg key
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
#Add the Jenkins repository
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install jenkins -y

#Increase /tmp filesystem, as it’s a RAM, it needs minimum 2GB to run Jenkins, use below script to expand /tmp size. the cleanest approach is to create a systemd drop-in override from a Bash script instead of editing /usr/lib/systemd/system/tmp.mount. As original stored here /usr/lib/systemd/system/tmp.mount. we cant disturb that.


sudo mkdir -p /etc/systemd/system/tmp.mount.d

cat > /etc/systemd/system/tmp.mount.d/override.conf <<'EOF'
[Mount]
Options=mode=1777,strictatime,nosuid,nodev,size=2G,nr_inodes=1m,x-systemd.graceful-option=usrquota
EOF

sudo systemctl daemon-reload
sudo systemctl restart tmp.mount
systemctl enable jenkins

sudo reboot


