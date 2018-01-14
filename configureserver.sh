#!/bin/bash

sudo apt-get update
sudo apt-get install -y build-essential python
sudo apt-get install -y python-pip
sudo apt-get install -y python-apt
sudo apt-get install -y awscli
sudo apt-get remove docker docker-engine docker.io
sudo apt-get update
sudo apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get -y install docker-ce
#aws configure