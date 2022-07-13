#!/usr/bin/env bash

set -eo pipefail

kubectl apply -k .
kubens gitlab-live

# helm upgrade --install gitlab-live gitlab/gitlab --namespace=gitlab-live --version=5.10.2 --values=values.yaml
