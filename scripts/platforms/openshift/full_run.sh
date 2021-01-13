#!/usr/bin/env bash

set -e

# IMPORTS

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/../../_common.sh"
source "${DIR}/_common.sh"

# CLEANUP

function cleanup {
    ${DIR}/destroy.sh
}

trap cleanup EXIT

# CREATE

${DIR}/create.sh

# SETUP

login_as_admin

${DIR}/../1_k8s_setup.sh

# TEST

${DIR}/../2_run_tests.sh $(get_tasks_to_test "${DIR}/../../../task")