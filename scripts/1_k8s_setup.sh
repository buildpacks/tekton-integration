#!/usr/bin/env bash

set -e

# IMPORTS

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/_common.sh"

# DEPENDENCIES

require_command $(get_kubectl_cmd)

# TASK

echo "> Installing tekton..."
kubectl_cmd apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

echo "> Waiting for pods to be ready..."
sleep 15
kubectl_cmd wait --for=condition=ready -n tekton-pipelines pods --timeout=120s --all
