#!/usr/bin/env bash

set -eo pipefail

kubectl apply -k .
helm upgrade --install bashhub-live erpf/bashhub --namespace=bashhub-live --version=0.1.13 --values=values.yaml
