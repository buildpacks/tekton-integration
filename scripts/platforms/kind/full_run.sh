#!/usr/bin/env bash

set -e

# IMPORTS

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/../../_common.sh"

# INPUTS

cluster_name="test-$(openssl rand -hex 12)"

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

${DIR}/../2_run_tests.sh $(get_tasks_to_test "${DIR}/../../../task")