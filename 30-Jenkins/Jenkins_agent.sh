#!/bin/bash

sudo apt update
sudo apt install openjdk-21-jdk -y
apt install awscli -y
#Add the Jenkins repository key

#Install growpart
apt install -y cloud-guest-utils

growpart /dev/nvme0n1 1
resize2fs /dev/nvme0n1p1

#Docker
sudo apt install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc


sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
sudo apt update -y


sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu

#eksctl
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_${PLATFORM}.tar.gz

tar -xzf eksctl_${PLATFORM}.tar.gz -C /tmp
rm eksctl_${PLATFORM}.tar.gz

sudo install -m 0755 /tmp/eksctl /usr/local/bin/eksctl
rm /tmp/eksctl

eksctl version

#Kubectl
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.35.3/2026-04-08/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo cp kubectl /usr/local/bin/kubectl

#Trivyscan
sudo apt-get install -y wget gnupg
#Trivy GPG Key
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key \
  | gpg --dearmor \
  | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null

#Add trivy repo
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" \
  | sudo tee /etc/apt/sources.list.d/trivy.list

sudo apt-get update
sudo apt-get install -y trivy

#Helm
sudo apt install -y curl gpg apt-transport-https
sudo rm -f /usr/share/keyrings/helm.gpg
curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey \
  | gpg --dearmor \
  | sudo tee /usr/share/keyrings/helm.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" \
  | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey \
  | gpg --dearmor \
  | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo chmod 644 /usr/share/keyrings/helm.gpg
sudo apt update
sudo apt install -y helm

#increase tmp size
sudo mkdir -p /etc/systemd/system/tmp.mount.d

cat > /etc/systemd/system/tmp.mount.d/override.conf <<'EOF'
[Mount]
Options=mode=1777,strictatime,nosuid,nodev,size=2G,nr_inodes=1m,x-systemd.graceful-option=usrquota
EOF

sudo systemctl daemon-reload
sudo systemctl restart tmp.mount

sudo reboot