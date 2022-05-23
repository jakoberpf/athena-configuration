#!/usr/bin/env bash

set -eo pipefail

masters+=$(kubectl get nodes -o custom-columns=NAME:.metadata.name --no-headers -l node-role.kubernetes.io/master)
for node in ${masters}; do
    echo "Labeling master node ${node}"
done

# kubectl label node <node-name> node-role.kubernetes.io/worker=worker
workers+=$(kubectl get nodes -o custom-columns=NAME:.metadata.name --no-headers -l node-role.kubernetes.io/worker)
for node in ${workers}; do
    echo "Labeling worker node ${node}"
    kubectl label nodes ${node} gitpod.io/workload_meta=true
    kubectl label nodes ${node} gitpod.io/workload_ide=true
    kubectl label nodes ${node} gitpod.io/workload_workspace_services=true
    kubectl label nodes ${node} gitpod.io/workload_workspace_regular=true
    kubectl label nodes ${node} gitpod.io/workload_workspace_headless=true
done
