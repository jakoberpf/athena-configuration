#!/usr/bin/env bash

set -eo pipefail

kubectl apply -k .
kubens gitlab-dev

helm upgrade --install gitlab-dev /Users/jakoberpf/Code/jakoberpf/kubernetes/charts/charts/gitlab --namespace=gitlab-dev --values=values.yaml

# helm upgrade --install gitlab-mattermost mattermost/mattermost-team-edition --namespace=gitlab --version=6.6.3 --values=values.mattermost.yaml