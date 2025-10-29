#!/bin/bash
# ==============================================================
# Script d'installation et de déploiement complet du VPN StrongSwan
# ==============================================================

set -e

echo "🚀 Lancement du déploiement complet VPN StrongSwan..."

# Vérifie que Vagrant est installé
if ! command -v vagrant &> /dev/null; then
    echo "❌ Vagrant n'est pas installé. Installe-le avant de continuer."
    exit 1
fi

# Vérifie qu'Ansible est installé
if ! command -v ansible &> /dev/null; then
    echo "❌ Ansible n'est pas installé. Installe-le avant de continuer."
    exit 1
fi

# 1️⃣ Création et démarrage de la VM
echo "🖥️  Création et démarrage de la VM Vagrant..."
vagrant up

# 2️⃣ Récupération de l'adresse IP de la VM
IP=$(vagrant ssh-config | awk '/HostName/ { print $2 }' | head -1)
echo "✅ VM en ligne sur ${IP}"

# 3️⃣ Attente que SSH soit prêt
echo "⏳ Attente que SSH soit disponible..."
sleep 10

# 4️⃣ Déploiement du VPN avec Ansible
echo "🔧 Déploiement de la configuration VPN StrongSwan..."
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/deploy_vpn.yml

# 5️⃣ Vérification finale
echo "✅ Déploiement terminé avec succès !"
echo "-----------------------------------------"
echo "🌐 VPN StrongSwan est maintenant actif sur ${IP}"
echo "📜 Pour vérifier le service : vagrant ssh vpn01 -c 'sudo systemctl status strongswan'"
echo "-----------------------------------------"
