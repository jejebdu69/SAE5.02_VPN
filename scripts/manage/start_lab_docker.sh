#!/bin/bash
set -e

# ----------------------------
# Détection Docker Compose v1 / v2
# ----------------------------
if command -v docker-compose >/dev/null 2>&1; then
    DOCKER_COMPOSE="docker-compose"
elif command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    DOCKER_COMPOSE="docker compose"
else
    echo "❌ Docker Compose introuvable ! Installez docker-compose ou mettez à jour Docker."
    exit 1
fi

echo "🛠 Utilisation de : $DOCKER_COMPOSE"

# ----------------------------
# Variables
# ----------------------------
SSH_KEY="$HOME/.ssh/ansible_docker_key"
INVENTORY="ansible/inventory/hosts_docker.ini"
PLAYBOOK_VPN="ansible/playbooks/deploy_vpn.yml"
PLAYBOOK_CLIENT="ansible/playbooks/deploy_client.yml"
CONTAINERS=("vpn01:2222" "client01:2223")

# ----------------------------
# 1️⃣ Génération clé SSH si absente
# ----------------------------
if [ ! -f "$SSH_KEY" ]; then
    echo "🔑 Génération de la clé SSH pour Ansible..."
    ssh-keygen -t rsa -b 4096 -f "$SSH_KEY" -N ""
fi

# ----------------------------
# 2️⃣ Construction et démarrage des conteneurs Docker
# ----------------------------
echo "🚀 Construction et démarrage des conteneurs Docker..."
cd docker
$DOCKER_COMPOSE up -d --build
cd - > /dev/null

# ----------------------------
# 3️⃣ Copier clé SSH dans les conteneurs
# ----------------------------
for c in "${CONTAINERS[@]}"; do
    NAME="${c%%:*}"
    echo "📦 Copie de la clé SSH dans $NAME..."
    docker exec -it $NAME mkdir -p /home/ansible/.ssh
    docker cp "$SSH_KEY.pub" $NAME:/home/ansible/.ssh/authorized_keys
    docker exec -it $NAME chown -R ansible:ansible /home/ansible/.ssh
    docker exec -it $NAME chmod 700 /home/ansible/.ssh
    docker exec -it $NAME chmod 600 /home/ansible/.ssh/authorized_keys
done

# ----------------------------
# 4️⃣ Attente que SSH soit prêt
# ----------------------------
echo "⏳ Attente que SSH soit prêt sur les conteneurs..."
for c in "${CONTAINERS[@]}"; do
    NAME="${c%%:*}"
    PORT="${c##*:}"
    until nc -zv 127.0.0.1 $PORT 2>/dev/null; do
        sleep 1
    done
done
echo "✅ SSH prêt sur tous les conteneurs."

# ----------------------------
# 5️⃣ Déploiement Ansible
# ----------------------------
echo "🧱 Déploiement du serveur VPN (Docker)..."
ansible-playbook -i $INVENTORY $PLAYBOOK_VPN

echo "💻 Déploiement du client VPN (Docker)..."
ansible-playbook -i $INVENTORY $PLAYBOOK_CLIENT

# ----------------------------
# 6️⃣ Fin
# ----------------------------
echo "✅ VPN opérationnel (Docker) !"
echo "--------------------------------------------------------"
echo "🔗 Pour vous connecter sur le client :"
echo "  docker exec -it client01 bash"
echo "  ipsec up vpn"
echo "--------------------------------------------------------"
echo "🔗 Pour voir les connexions sur le serveur :"
echo "  docker exec -it vpn01 bash"
echo "  ipsec status"
