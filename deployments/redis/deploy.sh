#!/usr/bin/env bash

set -eo pipefail

kubectl apply -k .
helm upgrade --install redis bitnami/redis --namespace=redis --version=16.9.11 --values=values.yaml
