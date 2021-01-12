#!/usr/bin/env bash

set -e

# IMPORTS

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/../_common.sh"
source "${DIR}/_common.sh"

# DEPENDENCIES

require_command crc
require_command jq
require_command oc

# TASK

## create cluster

echo "> Starting a new cluster..."
crc start

echo "> Logging in as admin..."
login_as_admin

echo "> Current kubectl context: $(kubectl config current-context)"

echo "> Setting up project for tekton..."
if [ -z "$(oc projects -q | grep tekton-pipelines)" ]; then
    oc new-project tekton-pipelines --display-name='Tekton Pipelines'
fi

oc adm policy add-scc-to-user anyuid -z tekton-pipelines-controller
oc project tekton-pipelines