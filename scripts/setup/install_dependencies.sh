#!/usr/bin/env bash
set -e
sudo apt update
sudo apt install -y strongswan strongswan-pki libstrongswan-extra-plugins iproute2 net-tools ufw openssl ansible docker.io
