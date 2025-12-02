#!/bin/bash

# Fichiers à modifier
FILE_SERVER="ansible/roles/strongswan/vars/main.yml"
FILE_CLIENT="ansible/roles/client/vars/main.yml"

# Vérif fichiers
if [ ! -f "$FILE_SERVER" ] || [ ! -f "$FILE_CLIENT" ]; then
    echo "Erreur : un des fichiers YAML est introuvable."
    exit 1
fi

# Menu principal
CHOICE=$(dialog --clear \
        --backtitle "Configuration VPN" \
        --title "Menu principal" \
        --menu "Sélectionnez une action :" 20 60 10 \
        1 "Configurer mode : PSK" \
        2 "Configurer mode : RSA" \
        3 "Configurer mode : MSCHAPv2" \
        4 "Supprimer le lab (destroy_lab.sh)" \
        5 "Allumer les machines (vagrant up)" \
        6 "Éteindre les machines (vagrant halt)" \
        2>&1 >/dev/tty)

clear

case $CHOICE in

    # Choix des modes d'authentification
    1) MODE="psk" ;;
    2) MODE="rsa" ;;
    3) MODE="mschapv2" ;;

    # Suppression du lab
    4)
        echo "🔻 Suppression du lab..."
        ./scripts/manage/destroy_lab.sh
        echo "Lab supprimé."
        exit 0
        ;;

    # Allumer les machines Vagrant
    5)
        echo "🚀 Démarrage des machines..."
        vagrant up
        exit 0
        ;;

    # Éteindre les machines Vagrant
    6)
        echo "🛑 Extinction des machines..."
        vagrant halt
        exit 0
        ;;

    *)
        echo "Annulé."
        exit 1
        ;;
esac


# ----------- Si choix PSK / RSA / MSCHAPv2 → alors on configure ----------
echo "Mode choisi : $MODE"
sleep 1

echo "Modification des fichiers YAML..."

sed -i "s/^mode_auth:.*/mode_auth: $MODE/" "$FILE_SERVER"
sed -i "s/^mode_auth:.*/mode_auth: $MODE/" "$FILE_CLIENT"

echo "Fichiers modifiés."
sleep 1

echo "🚀 Démarrage du lab..."
./scripts/manage/start_lab.sh

