#!/usr/bin/env bash

set -eo pipefail

kubectl apply -k .
helm upgrade --install teleport /Users/jakoberpf/Code/jakoberpf/kubernetes/charts/charts/teleport --namespace=teleport --values=values.yaml
