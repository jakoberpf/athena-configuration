#!/usr/bin/env bash

set -eo pipefail

kubectl apply -k .
helm upgrade --install bashhub erpf/bashhub --namespace=bashhub --version=0.1.13 --values=values.yaml
