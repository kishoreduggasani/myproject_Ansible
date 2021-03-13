#!/bin/bash
sudo yum -y install epel-release
sudo yum -y install ansible
sudo yum -y install git
sudo yum -y install unzip
sudo yum -y install vim
cd /home/centos/
sudo git clone https://github.com/kishoreduggasani/myproject_Ansible.git
sudo chown -R centos:centos myproject_Ansible

