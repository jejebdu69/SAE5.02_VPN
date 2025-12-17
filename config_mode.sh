#!/bin/bash

# Fichiers à modifier
FILE_SERVER="ansible/roles/strongswan/vars/main.yml"
FILE_CLIENT="ansible/roles/client/vars/main.yml"

# Vérif fichiers
if [ ! -f "$FILE_SERVER" ] || [ ! -f "$FILE_CLIENT" ]; then
    echo "Erreur : un des fichiers YAML est introuvable."
    exit 1
fi

# Lecture du mode actuel depuis le fichier server (supposé identique dans client)
MODE=$(grep '^mode_auth:' "$FILE_SERVER" | awk '{print $2}')
[ -z "$MODE" ] && MODE="Non défini"

# Boucle pour rester dans le menu
while true; do
    CHOICE=$(dialog --clear \
            --backtitle "Configuration VPN" \
            --title "Mode actuel : $MODE" \
            --menu "Sélectionnez une action :" 20 70 12 \
            1 "Configurer mode : PSK" \
            2 "Configurer mode : RSA" \
            3 "Configurer mode : MSCHAPv2" \
            4 "Supprimer le lab Vagrant (destroy_lab.sh)" \
            5 "Démarrer le lab Vagrant (start_lab.sh)" \
            6 "Supprimer le lab Docker (destroy_lab_docker.sh)" \
            7 "Démarrer le lab Docker (start_lab_docker.sh)" \
            8 "Quitter" \
            2>&1 >/dev/tty)

    clear

    case $CHOICE in
        1) MODE="psk" ;;
        2) MODE="rsa" ;;
        3) MODE="mschapv2" ;;

        4)
            echo "🔻 Suppression du lab Vagrant..."
            ./scripts/manage/destroy_lab.sh
            echo "Lab Vagrant supprimé."
            sleep 1
            continue
            ;;

        5)
            echo "🚀 Démarrage du lab Vagrant..."
            ./scripts/manage/start_lab.sh
            exit 0
            ;;

        6)
            echo "🔻 Suppression du lab Docker..."
            ./scripts/manage/destroy_lab_docker.sh
            echo "Lab Docker supprimé."
            sleep 1
            continue
            ;;

        7)
            echo "🚀 Démarrage du lab Docker..."
            ./scripts/manage/start_lab_docker.sh
            exit 0
            ;;

        8)
            echo "✅ Au revoir !"
            exit 0
            ;;

        *)
            echo "Annulé."
            exit 1
            ;;
    esac

    # Si on est sur un mode d'authentification, on modifie les fichiers
    if [[ "$CHOICE" =~ ^[1-3]$ ]]; then
        echo "Mode choisi : $MODE"
        sleep 1
        echo "Modification des fichiers YAML..."
        sed -i "s/^mode_auth:.*/mode_auth: $MODE/" "$FILE_SERVER"
        sed -i "s/^mode_auth:.*/mode_auth: $MODE/" "$FILE_CLIENT"
        echo "Fichiers modifiés."
        sleep 1
    fi
done
