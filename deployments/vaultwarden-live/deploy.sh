#!/usr/bin/env bash

set -eo pipefail

kubectl apply -k .
helm upgrade --install vaultwarden-live erpf/vaultwarden --namespace=vaultwarden-live --version=0.1.9 --values=values.yaml
