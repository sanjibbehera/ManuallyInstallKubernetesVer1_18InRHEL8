#!/bin/bash

sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo

sudo dnf install docker-ce --nobest -y
sudo systemctl start docker
sudo systemctl enable docker