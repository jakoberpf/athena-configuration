#!/usr/bin/env bash

set -eo pipefail

kubectl apply -k .
helm upgrade --install teleport-dev /Users/jakoberpf/Code/jakoberpf/kubernetes/charts/charts/teleport --namespace=teleport-dev --values=values.yaml
