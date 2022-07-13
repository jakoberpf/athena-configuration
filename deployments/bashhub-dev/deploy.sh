#!/usr/bin/env bash

set -eo pipefail

kubectl apply -k .
kubens bashhub-dev
helm upgrade --install bashhub erpf/bashhub --namespace=bashhub-dev --version=0.1.13 --values=values.yaml
