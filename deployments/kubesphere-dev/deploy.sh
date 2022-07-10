#!/usr/bin/env bash

set -eo pipefail

kubectl apply -k .

kubectl apply -f kubesphere-installer.yaml
kubectl apply -f cluster-configuration.yaml

kubectl logs -n kubesphere-system $(kubectl get pod -n kubesphere-system -l 'app in (ks-install, ks-installer)' -o jsonpath='{.items[0].metadata.name}') -f