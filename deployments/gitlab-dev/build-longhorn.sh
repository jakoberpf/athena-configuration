#!/usr/bin/env bash

set -eo pipefail

PROJECT_DIR="."
DOCKER_IMAGE="jakoberpf/longhorn-api"
DOCKER_BUILDX_ARCH="linux/amd64,linux/arm64"

echo "[debug] Rebuilding image with buildx"
echo "[troubleshooting] '/bin/sh: Invalid ELF image for this architecture' -> 'docker run --rm --privileged multiarch/qemu-user-static --reset -p yes'"

if [[ -z $(docker buildx ls | grep erpf_multiarch) ]]; then
    docker buildx create --name erpf_multiarch --platform linux/amd64,linux/arm64 --use
fi

docker buildx inspect erpf_multiarch --bootstrap
BUILD_CMD="docker buildx build --platform $DOCKER_BUILDX_ARCH -t ${DOCKER_IMAGE} ${PROJECT_DIR}"

for value in $DOCKER_BUILD_ARGS; do
    BUILD_CMD="$BUILD_CMD --build-arg $value"
done

BUILD_CMD="$BUILD_CMD --push"

echo ${BUILD_CMD}
eval ${BUILD_CMD}