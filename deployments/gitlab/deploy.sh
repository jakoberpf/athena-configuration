#!/usr/bin/env bash

set -e
set -o pipefail

kubectl apply -k .
helm upgrade --install gitlab gitlab/gitlab --namespace=gitlab --version=5.10.2 --values=values.yaml 
helm upgrade --install gitlab mattermost/mattermost-team-edition --namespace=gitlab --version=6.6.3 --values=values.mattermost.yaml