#!/usr/bin/env bash
set -e
mkdir -p logs/vpn
sudo journalctl -u strongswan-starter > logs/vpn/connections.log
echo "Logs exportés dans logs/vpn/"
