#!/usr/bin/env bash

set -eo pipefail

kubectl apply -f kubesphere-installer.yaml

sleep 5 # give some time to digest CRDs creation

kubectl apply -f cluster-configuration.yaml

sleep 1

kubectl apply -k .

sleep 20 # give some time allow container creation

kubectl logs -n kubesphere-system $(kubectl get pod -n kubesphere-system -l 'app in (ks-install, ks-installer)' -o jsonpath='{.items[0].metadata.name}') -f
