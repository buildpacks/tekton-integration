#!/usr/bin/env bash

set -e

# IMPORTS

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/../_common.sh"

# CONFIGURATION

KUBECTLCMD=$(env_or_default KUBECTLCMD kubectl)

# DEPENDENCIES

require_command $KUBECTLCMD

# TASK

echo "> Installing tekton..."
$KUBECTLCMD apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

echo "> Waiting for pods to be ready..."
sleep 15
$KUBECTLCMD wait --for=condition=ready -n tekton-pipelines pods --timeout=120s --all
