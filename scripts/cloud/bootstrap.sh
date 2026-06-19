#!/usr/bin/env bash
set -euo pipefail

ENV="${ENV:-prod}"
SERVER_IP="${SERVER_IP:-}"
SSH_USER="${SSH_USER:-root}"
SSH_PORT="${SSH_PORT:-22}"
SSH_ID_FILE="${SSH_ID_FILE:-}"

if [[ -z "${SERVER_IP}" ]]; then
  echo "ENV=prod|dev SERVER_IP=... ./scripts/cloud/bootstrap.sh"
  exit 1
fi

if [[ "${ENV}" != "prod" && "${ENV}" != "dev" ]]; then
  echo "ENV должен быть prod или dev"
  exit 1
fi

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
KUBECONFIG_FILE="${HOME}/.kube/k3s-argocd-${ENV}.yaml"
SSH_TARGET="${SSH_USER}@${SERVER_IP}"
CONTROL_PATH="/tmp/argoCD-ssh-${ENV}-${SSH_USER}-${SERVER_IP}-${SSH_PORT}"
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

echo "==> Bootstrap ${ENV} на ${SSH_TARGET}"

ssh_cmd 'bash -s' < "${ROOT}/scripts/cloud/install-k3s.sh"

mkdir -p "${HOME}/.kube"
ssh_cmd cat /etc/rancher/k3s/k3s.yaml | \
  sed "s/127.0.0.1/${SERVER_IP}/g" > "${KUBECONFIG_FILE}"

export KUBECONFIG="${KUBECONFIG_FILE}"
kubectl cluster-info

bash "${ROOT}/scripts/cloud/install-argocd.sh"

echo ""
echo "Дальше:"
echo "  ENV=${ENV} ./scripts/apply-environment.sh"
echo "  ENV=${ENV} ./scripts/access-argocd.sh"
echo "  KUBECONFIG=${KUBECONFIG_FILE}"
