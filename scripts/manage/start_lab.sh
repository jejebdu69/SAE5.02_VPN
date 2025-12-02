#!/bin/bash
set -e

echo "🚀 Initialisation du lab VPN complet..."
vagrant up

echo "🧱 Déploiement du serveur VPN..."
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/deploy_vpn.yml

echo "💻 Déploiement du client VPN..."
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/deploy_client.yml

echo "✅ VPN opérationnel !"
echo "--------------------------------------------------------"
echo "🔗 Pour vous connecter sur le client :"
echo "  vagrant ssh client01"
echo "  sudo ipsec up vpn"
echo "--------------------------------------------------------"
echo "🔗 Pour voir les connections sur le serveur :"
echo "  vagrant ssh vpn01"
echo "  sudo ipsec status"

