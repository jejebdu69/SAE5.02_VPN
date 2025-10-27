#!/usr/bin/env bash
set -e
sudo ipsec start
sudo systemctl start strongswan-starter
sudo ipsec statusall || true
echo "VPN démarré"