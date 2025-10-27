#!/usr/bin/env bash
set -e
sudo systemctl stop strongswan-starter || true
sudo ipsec stop || true
echo "VPN arrêté"