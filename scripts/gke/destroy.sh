#!/usr/bin/env bash

set -e

# IMPORTS

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/../_common.sh"

# DEPENDENCIES

require_command terraform

# INPUTS

if [ "$1" = "" ];then
  echo "Usage: ${BASH_SOURCE[0]} <cluster-name>"
  exit 1
fi

cluster_name=$1

# DEPENDENCIES

require_command terraform

# TASK
pushd ${DIR} > /dev/null

  echo "> Deleting cluster (${cluster_name})..."
  terraform destroy -var="cluster_name=${cluster_name}"

popd > /dev/null