#!/usr/bin/env bash
set -e
mkdir -p /logs
echo "Collecte en cours (monter /var/log depuis l'hôte ou un volume)..."
tail -F /var/log/syslog
