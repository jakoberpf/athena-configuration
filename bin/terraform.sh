#!/usr/bin/env bash

set -e
set -o pipefail

GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Run terraform apply
cd dns
terragrunt init -backend-config=backend.conf -upgrade
terragrunt apply
cd $GIT_ROOT