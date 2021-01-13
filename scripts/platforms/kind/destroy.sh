#!/usr/bin/env bash

set -e

# IMPORTS

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/../../_common.sh"

# INPUTS

if [ "$1" = "" ];then
  echo "Usage: ${BASH_SOURCE[0]} <cluster-name>"
  exit 1
fi

cluster_name=$1

# DEPENDENCIES

require_command kind

# TASK

echo "> Deleting cluster (${cluster_name})..."
kind delete cluster --name ${cluster_name}