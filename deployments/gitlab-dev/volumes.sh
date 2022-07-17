#!/usr/bin/env bash

set -eo pipefail

kubectl port-forward services/longhorn-frontend 8080:http -n longhorn-system

docker run --rm --mount type=bind,source="$PWD"/config.yaml,dst=/longhorn/config.yaml docker.io/jakoberpf/longhorn-api