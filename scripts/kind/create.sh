#!/usr/bin/env bash

set -e

# IMPORTS

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/../_common.sh"

# DEPENDENCIES

require_command kind

# INPUTS

if [ "$1" = "" ];then
    cluster_name="test-$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-z0-9' | fold -w 10 | head -n 1)"
else
    cluster_name=$1
fi

# TASK

## create cluster

echo "> Starting a new cluster (${cluster_name})..."
kind create cluster --name ${cluster_name}