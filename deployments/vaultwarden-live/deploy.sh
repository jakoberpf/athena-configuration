#!/usr/bin/env bash

set -eo pipefail

kubectl apply -k .
helm upgrade --install vaultwarden erpf/vaultwarden --namespace=vaultwarden-live --version=0.1.8 --values=values.yaml
