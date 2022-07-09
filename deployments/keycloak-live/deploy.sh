#!/usr/bin/env bash

set -eo pipefail

kubectl apply -k .

helm upgrade --install keycloak-live erpf/keycloak --namespace=keycloak-live  --version=0.0.1 --values=values.yaml
