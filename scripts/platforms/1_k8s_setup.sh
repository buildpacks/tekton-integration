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

# disable error propogation
set +e

$KUBECTLCMD wait --for=condition=ready -n tekton-pipelines pods --timeout=300s --all
wait_rc="${?}"

# re-enable error propogation
set -e

if [ "${wait_rc}" -ne 0 ]; then
    echo "Failed to start pods..."
    echo "Current pod status: "
    $KUBECTLCMD get -n tekton-pipelines pods

    # Write an informative error message and halt the script with an `exit 1`, or
    # perhaps let it continue onwards, depending on what you're doing.
    exit 1
fi
