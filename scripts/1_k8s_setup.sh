#!/usr/bin/env bash

set -e

# IMPORTS

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/_common.sh"

# DEPENDENCIES

require_command kubectl

# TASK

echo "> Installing tekton..."
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

echo "> Waiting for pods to be ready..."
sleep 15
kubectl wait --for=condition=ready -n tekton-pipelines pods --timeout=120s --all
