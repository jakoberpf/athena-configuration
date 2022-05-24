#!/usr/bin/env bash

set -eo pipefail

kubectl apply -k .
helm upgrade --install postgresql bitnami/postgresql-ha --namespace=postgresql --version=9.0.11 --values=values.yaml
