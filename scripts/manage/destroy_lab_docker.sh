#!/bin/bash

echo "🧹 Suppression complète du lab VPN (Docker)..."

# Détection docker compose v1 / v2
if command -v docker-compose >/dev/null 2>&1; then
    DOCKER_COMPOSE="docker-compose"
else
    DOCKER_COMPOSE="docker compose"
fi

cd docker
$DOCKER_COMPOSE down -v
cd - > /dev/null

rm -rf shared_certs/

echo "✅ Environnement Docker nettoyé."
