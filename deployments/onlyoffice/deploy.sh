#!/usr/bin/env bash

set -eo pipefail

kubectl apply -k .
helm upgrade --install onlyoffice /Users/jakoberpf/Code/jakoberpf/kubernetes/charts/charts/onlyoffice --namespace=onlyoffice --values=values.yaml
