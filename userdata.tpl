#!/bin/bash
sudo apt update -y &&
sudo apt install -y \
apt-transport-https \
ca-certificates \
curl \
gnupg \
lsb-release \
software-properties-common &&
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" &&
sudo apt update -y &&
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin &&
sudo usermod -aG docker ubuntu
