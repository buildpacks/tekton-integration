#!/usr/bin/env bash

set -e

# IMPORTS

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/../_common.sh"

# INPUTS

cluster_name="test-$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-z0-9' | fold -w 10 | head -n 1)"

# CLEANUP

function cleanup {
    ${DIR}/destroy.sh ${cluster_name}
}

trap cleanup EXIT

# CREATE

${DIR}/create.sh ${cluster_name}

# SETUP

${DIR}/../1_k8s_setup.sh

# TEST

${DIR}/../2_run_tests.sh