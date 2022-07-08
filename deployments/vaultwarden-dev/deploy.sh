#!/usr/bin/env bash

set -eo pipefail

kubectl apply -k .
helm upgrade --install vaultwarden-dev erpf/vaultwarden --namespace=vaultwarden-dev --version=0.1.9 --values=values.yaml
