#!/usr/bin/env bash

set -e

# IMPORTS

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/_common.sh"

# INPUT

if [[ "$#" -ne 2 ]]; then
  echo "Usage: ${BASH_SOURCE[0]} <pipeline-or-task-dir> <catalog-repo-dir>"
  exit 1
fi

RESOURCE_DIR=$(realpath "$1")
if [ ! -d "$RESOURCE_DIR" ]; then
    echo "$RESOURCE_DIR not found!"
fi

CATALOG_DIR=$(realpath "$2")
if [ ! -d "$CATALOG_DIR" ]; then
    echo "$CATALOG_DIR not found!"
fi

# TASK

TYPE=$(echo "$RESOURCE_DIR" | rev | cut -d'/' -f3 | rev)
NAME=$(echo "$RESOURCE_DIR" | rev | cut -d'/' -f2 | rev)
VERSION=$(echo "$RESOURCE_DIR" | rev | cut -d'/' -f1 | rev)

DESTINATION_DIR="${CATALOG_DIR}/${TYPE}/${NAME}/${VERSION}"

echo "> Copying to ${DESTINATION_DIR}..."
mkdir -p "$DESTINATION_DIR"

cp -R "$RESOURCE_DIR"/* "$DESTINATION_DIR"

echo "> Updating some content..."

echo "--> Update resource URL in README.md..."
sed -i "" 's;buildpacks/tekton-integration/main;tektoncd/catalog/main;g' "${DESTINATION_DIR}/README.md"
sed -i "" 's;buildpacks/tekton-integration/tree/main;tektoncd/catalog/tree/main;g' "${DESTINATION_DIR}/README.md"

echo "> Cleaning up..."

echo "--> Remove comments from README.md..."
sed -i "" '/<!--/d' "${DESTINATION_DIR}/README.md"

echo "--> Remove README.md template file..."
rm "${DESTINATION_DIR}/README.tpl.md"

echo "> Done!"
echo
echo "> These are all the changes:"
pushd $CATALOG_DIR > /dev/null
    git status -u
popd > /dev/null