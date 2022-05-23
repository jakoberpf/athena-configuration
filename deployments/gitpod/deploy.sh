#!/usr/bin/env bash

set -eo pipefail

kubectl apply -k .
kubens gitpod
kubectl kots install gitpod
