#!/usr/bin/env bash
set -euo pipefail

SERVER_IP="${SERVER_IP:-}"
SSH_USER="${SSH_USER:-root}"

if [[ -z "${SERVER_IP}" ]]; then
  echo "Укажи IP VPS: SERVER_IP=1.2.3.4 ./scripts/cloud/bootstrap.sh"
  exit 1
fi

ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"

echo "==> 1/3 k3s на ${SSH_USER}@${SERVER_IP}"
ssh "${SSH_USER}@${SERVER_IP}" 'bash -s' < "${ROOT}/scripts/cloud/install-k3s.sh"

echo "==> 2/3 Копируем kubeconfig"
mkdir -p "${HOME}/.kube"
ssh "${SSH_USER}@${SERVER_IP}" cat /etc/rancher/k3s/k3s.yaml | \
  sed "s/127.0.0.1/${SERVER_IP}/g" > "${HOME}/.kube/k3s-argocd-learning.yaml"

export KUBECONFIG="${HOME}/.kube/k3s-argocd-learning.yaml"
kubectl cluster-info

echo "==> 3/3 ArgoCD"
bash "${ROOT}/scripts/cloud/install-argocd.sh"

echo ""
echo "Дальше на сервере или с KUBECONFIG=${KUBECONFIG}:"
echo "  kubectl apply -f apps/root.yaml"
echo ""
echo "ArgoCD UI: kubectl port-forward svc/argocd-server -n argocd 8080:443"
