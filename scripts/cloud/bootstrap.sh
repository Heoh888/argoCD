#!/usr/bin/env bash
set -euo pipefail

SERVER_IP="${SERVER_IP:-}"
SSH_USER="${SSH_USER:-root}"
SSH_PORT="${SSH_PORT:-22}"
SSH_ID_FILE="${SSH_ID_FILE:-}"

if [[ -z "${SERVER_IP}" ]]; then
  echo "Укажи IP VPS: SERVER_IP=1.2.3.4 ./scripts/cloud/bootstrap.sh"
  exit 1
fi

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SSH_TARGET="${SSH_USER}@${SERVER_IP}"
CONTROL_PATH="/tmp/argoCD-ssh-${SSH_USER}-${SERVER_IP}-${SSH_PORT}"
SSH_BASE=(
  -p "${SSH_PORT}"
  -o StrictHostKeyChecking=accept-new
  -o ControlMaster=auto
  -o "ControlPath=${CONTROL_PATH}"
  -o ControlPersist=300
)
if [[ -n "${SSH_ID_FILE}" ]]; then
  SSH_BASE+=(-i "${SSH_ID_FILE}" -o IdentitiesOnly=yes)
fi

ssh_cmd() {
  if [[ -n "${SSHPASS:-}" ]] && command -v sshpass &>/dev/null; then
    sshpass -e ssh "${SSH_BASE[@]}" "${SSH_TARGET}" "$@"
  else
    ssh "${SSH_BASE[@]}" "${SSH_TARGET}" "$@"
  fi
}

cleanup_ssh() {
  ssh -S "${CONTROL_PATH}" -O exit "${SSH_TARGET}" 2>/dev/null || true
}
trap cleanup_ssh EXIT

echo "==> SSH: ${SSH_TARGET}"
echo "    Пароль запросится один раз (или: ssh-copy-id ${SSH_TARGET})"
echo "    Или: SSHPASS='пароль' ./scripts/cloud/bootstrap.sh (нужен sshpass)"

echo "==> 1/3 k3s"
ssh_cmd 'bash -s' < "${ROOT}/scripts/cloud/install-k3s.sh"

echo "==> 2/3 kubeconfig"
mkdir -p "${HOME}/.kube"
ssh_cmd cat /etc/rancher/k3s/k3s.yaml | \
  sed "s/127.0.0.1/${SERVER_IP}/g" > "${HOME}/.kube/k3s-argocd-learning.yaml"

export KUBECONFIG="${HOME}/.kube/k3s-argocd-learning.yaml"
kubectl cluster-info

echo "==> 3/3 ArgoCD"
bash "${ROOT}/scripts/cloud/install-argocd.sh"

echo ""
echo "Дальше:"
echo "  export KUBECONFIG=${KUBECONFIG}"
echo "  kubectl apply -f apps/root.yaml"
echo "  ./scripts/access-argocd.sh"
