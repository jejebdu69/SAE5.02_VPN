#!/bin/bash
echo "🧹 Suppression complète du lab VPN..."
vagrant destroy -f
rm -rf shared_certs/
rm -rf .vagrant
echo "✅ Environnement nettoyé."
