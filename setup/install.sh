#!/bin/bash

apt-get update
apt-get install wget

wget -qO- https://get.docker.com/ | sh
docker pull swarm
