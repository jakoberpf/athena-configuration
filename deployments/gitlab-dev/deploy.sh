#!/usr/bin/env bash

set -eo pipefail

kubectl apply -k .

helm upgrade --install gitlab gitlab/gitlab --namespace=gitlab-dev --version=5.10.2 --values=values.yaml 

# helm upgrade --install gitlab-mattermost mattermost/mattermost-team-edition --namespace=gitlab --version=6.6.3 --values=values.mattermost.yaml