#!/bin/bash

echo "========================================"
echo "  Démarrage de NGROK pour Jenkins"
echo "========================================"
echo ""
echo "Assurez-vous que Jenkins est démarré sur le port 8080"
echo ""
read -p "Appuyez sur Entrée pour continuer..."
echo ""
echo "Démarrage de NGROK..."
echo ""
ngrok http 8080

