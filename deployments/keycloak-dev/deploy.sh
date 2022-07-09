#!/usr/bin/env bash

set -eo pipefail

kubectl apply -k .

helm upgrade --install keycloak-dev /Users/jakoberpf/Code/jakoberpf/kubernetes/charts/charts/keycloak --namespace=keycloak-dev --values=values.yaml
