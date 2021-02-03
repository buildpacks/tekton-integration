#!/usr/bin/env bash

set -e

# IMPORTS

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/../../_common.sh"

# DEPENDENCIES

require_command kind

# INPUTS

if [ "$1" = "" ];then
    cluster_name="test-$(openssl rand -hex 12)"
else
    cluster_name=$1
fi

# TASK

## create cluster

echo "> Starting a new cluster (${cluster_name})..."
kind create cluster --name ${cluster_name}