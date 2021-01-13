#!/usr/bin/env bash

set -e

# IMPORTS

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/../../_common.sh"
source "${DIR}/_common.sh"

cluster_name=$1

# DEPENDENCIES

require_command crc

# TASK

echo "> Logging in as admin..."
login_as_admin

echo "> Deleting cluster..."
crc delete