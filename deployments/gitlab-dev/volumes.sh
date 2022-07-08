#!/usr/bin/env bash

set -eo pipefail

kubectl port-forward services/longhorn-frontend 8080:http -n longhorn-system