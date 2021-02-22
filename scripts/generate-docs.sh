#!/usr/bin/env bash

set -e

# IMPORTS

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/_common.sh"

# INPUT

if [[ "$#" -ne 1 ]]; then
  echo "Usage: ${BASH_SOURCE[0]} <pipeline-or-task-dir>"
  exit 1
fi

# DEPENDENCIES

require_command jq
require_command yj
require_command envsubst
require_command pack
require_command crane

# TASK

export TYPE=$(realpath $1 | rev | cut -d'/' -f3 | rev)
export NAME=$(realpath $1 | rev | cut -d'/' -f2 | rev)
export VERSION=$(realpath $1 | rev | cut -d'/' -f1 | rev)

DEFINITION="${DIR}/../${TYPE}/${NAME}/${VERSION}/${NAME}.yaml"
if [ ! -f "$DEFINITION" ]; then
    echo "${TYPE} definition '$DEFINITION' not found!"
fi

TEMPLATE="${DIR}/../${TYPE}/${NAME}/${VERSION}/README.tpl.md"
if [ ! -f "$TEMPLATE" ]; then
    echo "README template '$TEMPLATE' not found!"
fi

echo "> Gathering suggested builders..."
BUILDERS=""
for builder in $(pack builder suggest --no-color --quiet | cut -d "'" -f2); do
    description=$(crane config $builder | jq -r '.config.Labels["io.buildpacks.builder.metadata"] | fromjson | .description')
    if [[ "$description" == "" ]]; then
        BUILDERS+=" - **\`$builder\`**\n"
    else
        BUILDERS+=" - **\`$builder\`**: $description\n"
    fi
done
export BUILDERS=$(echo -e  "$BUILDERS")

echo "> Extracting workspaces..."
export WORKSPACES=$(cat "$DEFINITION" | yj | jq -r '.spec.workspaces[] | . + {"note": (if .optional then "_(optional)_" else "_(REQUIRED)_" end) } | " - **`\(.name)`**: \(.description) \(.note)"')

echo "> Extracting parameters..."
export PARAMETERS=$(cat "$DEFINITION" | yj | jq -r '.spec.params[] | . + {"note": (if .default then "_(optional, default: \"\(.default)\")_" else "_(REQUIRED)_" end) } | " - **`\(.name)`**: \(.description) \(.note)"')

echo "> Extracting metadata..."
export TEKTON_MIN_VERSION=$(cat "$DEFINITION" | yj | jq -r '.metadata.annotations["tekton.dev/pipelines.minVersion"]')
export DISPLAY_NAME=$(cat "$DEFINITION" | yj | jq -r '.metadata.annotations["tekton.dev/displayName"]')
export PLATFORM_API_VERSION=$(cat "$DEFINITION" | yj | jq -r '.spec.stepTemplate.env[] | select ( .name | contains("CNB_PLATFORM_API")) | .value')

export SUMMARY=$(cat <<EOF
This $TYPE builds source into a container image using [Cloud Native Buildpacks](https://buildpacks.io). To do that, it uses [builders](https://buildpacks.io/docs/concepts/components/builder/#what-is-a-builder) to run buildpacks against your application.

> _**What are Cloud Native Buildpacks?**_
> 
> _Cloud Native Buildpacks are pluggable, modular tools that transform application source code into OCI images. They replace Dockerfiles in the app development lifecycle, and enable for swift rebasing of images and modular control over images (through the use of builders), among other benefits._
EOF
)

DOCS_FILE="${DIR}/../${TYPE}/${NAME}/${VERSION}/README.md"
echo "> Writing docs to: ${DOCS_FILE}"
echo "<!-- NOTE: This file is auto-generated. Do not manually update! -->" > $DOCS_FILE
envsubst < "$TEMPLATE" >> "$DOCS_FILE"

cat "$DOCS_FILE"