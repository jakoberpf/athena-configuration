#!/usr/bin/env bash

namespace=gitlab-dev
lpname=longhorn-provisioner
# set -eo pipefail

kubens $namespace

helm uninstall gitlab-umbrella
helm uninstall gitlab-dev

# kubectl delete namespace $namespace

kubectl delete serviceaccount $lpname
kubectl delete clusterrole $lpname
kubectl delete clusterrolebinding $lpname