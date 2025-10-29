#!/bin/bash
echo "🧹 Suppression complète de l’environnement VPN..."
vagrant destroy -f
rm -rf .vagrant
echo "✅ Environnement supprimé proprement."
