#!/usr/bin/env bash

set -eo pipefail

kubectl apply -k .
kubectl scale deployment -n vaultwarden-live --replicas=0 vaultwarden-live
sleep 3
helm upgrade --install vaultwarden-live erpf/vaultwarden --namespace=vaultwarden-live --version=0.1.12 --values=values.yaml
kubectl scale deployment -n vaultwarden-live --replicas=1 vaultwarden-live