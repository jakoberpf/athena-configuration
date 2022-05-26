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

kubectl apply -k .
kubens gitpod
# kubectl kots install gitpod

docker build . -t gitpod-installer

docker run -it --rm \
  --name gitpod-installer \
  --volume "$(pwd)"/installer:/installer \
  gitpod-installer gitpod-installer init >> gitpod.config.yaml

docker run -it --rm \
  --name gitpod-installer \
  --volume "$(pwd)"/installer:/installer \
  gitpod-installer gitpod-installer validate config --config /installer/gitpod.config.yaml

docker run -it --rm \
  --name gitpod-installer \
  --volume "$(pwd)"/installer:/installer \
  --volume "$(pwd)"/../../.kube:/kube \
  gitpod-installer gitpod-installer validate cluster --kubeconfig /kube/admin.conf --config /installer/gitpod.config.yaml

docker run -it --rm \
  --name gitpod-installer \
  --volume "$(pwd)"/installer:/installer \
  gitpod-installer gitpod-installer render --config /installer/gitpod.config.yaml > installer/gitpod.deployment.yaml