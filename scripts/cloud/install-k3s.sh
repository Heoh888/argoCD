#!/usr/bin/env bash
# Запуск на VPS (Ubuntu): curl -sfL URL | bash
# или: ssh root@SERVER 'bash -s' < scripts/cloud/install-k3s.sh
set -euo pipefail

echo "==> Установка k3s без встроенного Traefik"
curl -sfL https://get.k3s.io | sh -s - server \
  --write-kubeconfig-mode 644 \
  --disable traefik \
  --tls-san "$(curl -sf ifconfig.me 2>/dev/null || hostname -I | awk '{print $1}')"

echo "k3s установлен."
echo "Kubeconfig: /etc/rancher/k3s/k3s.yaml"
