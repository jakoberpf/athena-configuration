#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Kubernetes admin config [live]
mkdir -p "$GIT_ROOT/.kube"
cd $GIT_ROOT/.kube

vault2env CICD/repo/athena-bootstrap/live/kube-secret .env
source .env

echo "$admin_conf" | base64 --decode > admin.conf

rm .env

# SSH Keys
mkdir -p "$GIT_ROOT/.ssh"
cd $GIT_ROOT/.ssh

vault2env CICD/global/ssh/automation .env
source .env

rm automation
echo "$PRIVAT_KEY_OPENSSH_PEM" | base64 --decode >> automation
chmod 600 automation

rm automation.pub
echo "$PUBLIC_KEY_SSH" | base64 --decode >> automation.pub
chmod 600 automation.pub

rm .env