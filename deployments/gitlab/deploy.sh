#!/usr/bin/env bash

set -eo pipefail

kubectl apply -k .
helm upgrade --install gitlab gitlab/gitlab --namespace=gitlab --version=5.10.2 --values=values.yaml 
helm upgrade --install gitlab-redis bitnami/redis --namespace=gitlab --version=16.9.11 --values=values.redis.yaml
helm upgrade --install gitlab-mattermost mattermost/mattermost-team-edition --namespace=gitlab --version=6.6.3 --values=values.mattermost.yaml