#!/bin/bash
# Server setup
sudo apt install nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx
cd /var/www/html/
sudo bash -c "echo 'Hello World<br> ' > index.html"
sudo bash -c "uname -sro >> index.html"

# Docker installation
sudo apt -y remove docker docker-engine docker.io containerd runc
sudo apt update
sudo apt -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
