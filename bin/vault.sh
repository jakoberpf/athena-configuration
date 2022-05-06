#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Kubernetes admin config [live]
mkdir -p "$GIT_ROOT/live/.kube"
cd $GIT_ROOT/live/.kube

vault2env CICD/repo/athena-bootstrap/live/kube-secret .env
source .env

echo "$admin_conf" | base64 --decode > admin.conf

rm .env
