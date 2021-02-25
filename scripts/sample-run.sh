#!/usr/bin/env bash

set -e

# IMPORTS

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/_common.sh"

# INPUT

if [[ "$#" -ne 2 ]]; then
  echo "Usage: ${BASH_SOURCE[0]} <path/to/sample.yaml> <image-name>"
  exit 1
fi

SAMPLE_FILE="$1"
if [ ! -f "$SAMPLE_FILE" ]; then
    echo "File '$SAMPLE_FILE' not found!"
fi

IMAGE_NAME="$2"

# DEPENDENCIES

require_command kubectl
require_command tkn

# TASK

echo "> Installing dependant tasks..."
kubectl apply -f https://raw.githubusercontent.com/tektoncd/catalog/master/task/git-clone/0.2/git-clone.yaml

echo "> Installing tasks..."
ls -1 task/buildpacks*/*/*.yaml | xargs -I '{}' sh -c 'echo "--> Installing {}..."; kubectl apply -f {}'

echo "> Installing pipelines..."
ls -1 pipeline/buildpacks*/*/*.yaml | xargs -I '{}' sh -c 'echo "--> Installing {}..."; kubectl apply -f {}'

echo "> Applying sample ..."
sed -e "s;<IMAGE_NAME>;${IMAGE_NAME};" $SAMPLE_FILE | kubectl apply -f -

echo "> Tailing logs..."
tkn pipelinerun logs -f