#!/usr/bin/env bash

set -e

# IMPORTS

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/_common.sh"

# INPUT

if [ "$1" = "" ];then
  echo "Usage: ${BASH_SOURCE[0]} <path/to/sample.yaml>..."
  exit 1
fi

SAMPLE_FILE="$1"
if [ ! -f "$SAMPLE_FILE" ]; then
    echo "File '$SAMPLE_FILE' not found!"
fi

# DEPENDENCIES

require_command kubectl

# TASK

echo "> Deleting tasks..."
ls -1 task/buildpacks*/*/*.yaml | xargs -I '{}' sh -c 'echo "--> Deleting {}..."; kubectl delete -f {}' || true

echo "> Deleting pipelines..."
ls -1 pipeline/buildpacks*/*/*.yaml | xargs -I '{}' sh -c 'echo "--> Deleting {}..."; kubectl delete -f {}' || true

echo "> Deleting sample ..."
kubectl delete -f $SAMPLE_FILE || true
