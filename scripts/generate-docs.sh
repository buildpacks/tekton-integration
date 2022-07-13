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

RESOURCE_DIR=$(realpath "$1")

# DEPENDENCIES

require_command jq
require_command yj
require_command envsubst
require_command pack
require_command crane

# TASK

export TYPE=$(echo "$RESOURCE_DIR" | rev | cut -d'/' -f3 | rev)
export NAME=$(echo "$RESOURCE_DIR" | rev | cut -d'/' -f2 | rev)
export VERSION=$(echo "$RESOURCE_DIR" | rev | cut -d'/' -f1 | rev)

DEFINITION="${RESOURCE_DIR}/${NAME}.yaml"
if [ ! -f "$DEFINITION" ]; then
    echo "${TYPE} definition '$DEFINITION' not found!"
fi

BASE_TEMPLATE_FILE="README.${TYPE}.tpl.md"
TEMPLATE_FILE="${DIR}/../templates/${BASE_TEMPLATE_FILE}"
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "README template '$TEMPLATE_FILE' not found!"
fi

echo "> Extracting workspaces..."
export WORKSPACES=$(cat "$DEFINITION" | yj | jq -r '.spec.workspaces[] | . + {"note": (if .optional then "_(optional)_" else "_(REQUIRED)_" end) } | " - **`\(.name)`**: \(.description) \(.note)"')

echo "> Extracting parameters..."
export PARAMETERS=$(cat "$DEFINITION" | yj | jq -r '.spec.params[] | . + {"default": (if .default and .type != "array" then "\"\(.default)\"" else .default end) } | . + {"note": (if .default then "_(optional, default: \(.default))_" else "_(REQUIRED)_" end) } | " - **`\(.name)`**: \(.description) \(.note)"')

echo "> Extracting results..."
export RESULTS=$(cat "$DEFINITION" | yj | jq -r '.spec.results[] | " - **`\(.name)`**: \(.description)"')

echo "> Collection samples for usage..."
SAMPLES_DIR="${RESOURCE_DIR}/samples"
SAMPLES=""
for sample in $(ls -1 "$SAMPLES_DIR"); do
    description=$(cat "${SAMPLES_DIR}/${sample}" | grep '^#' | sed 's/#[ \t]*//')
    url="samples/${sample}"
    if [[ "$description" == "" ]]; then
        SAMPLES+=" - **[\`$sample\`]($url)**\n"
    else
        SAMPLES+=" - **[\`$sample\`]($url)**: $description\n"
    fi
done
SAMPLES=$(echo -e  "$SAMPLES")
export SAMPLES=$(cat <<EOF
See the following samples for usage:

$SAMPLES
EOF
)

echo "> Extracting metadata..."
export TEKTON_MIN_VERSION=$(cat "$DEFINITION" | yj | jq -r '.metadata.annotations["tekton.dev/pipelines.minVersion"]')
export DISPLAY_NAME=$(cat "$DEFINITION" | yj | jq -r '.metadata.annotations["tekton.dev/displayName"]')
export PLATFORM_API_VERSION=$(cat "$DEFINITION" | yj | jq -r '.spec.stepTemplate.env[] | select ( .name | contains("CNB_PLATFORM_API")) | .value')

export SUMMARY=$(cat <<EOF
This $TYPE builds source into a container image using [Cloud Native Buildpacks](https://buildpacks.io). To do that, it uses [builders](https://buildpacks.io/docs/concepts/components/builder/#what-is-a-builder) to run buildpacks against your application source.

> _**What are Cloud Native Buildpacks?**_
> 
> _Cloud Native Buildpacks are pluggable, modular tools that transform application source code into OCI images. They replace Dockerfiles in the app development lifecycle, and enable for swift rebasing of images and modular control over images (through the use of builders), among other benefits._
EOF
)

if [ -z "${PLATFORM_API_VERSION}" ]; then
    PLATFORM_API_VERSION="_(determined by buildpack tasks used)_"
fi

export COMPATIBILITY=$(cat <<EOF
- **Tekton:** v${TEKTON_MIN_VERSION} and above
- **[Platform API][platform-api]:** ${PLATFORM_API_VERSION}
    > Be sure to also supply a compatible builder image (\`BUILDER_IMAGE\` input) when running the task (i.e. one that has a lifecycle that supports the Platform APIs).
- **OS/Arch:** linux/amd64
    > Other platforms may be supported if compatible images are used.

[platform-api]: https://buildpacks.io/docs/reference/spec/platform-api/
EOF
)

export SUPPORT=$(cat <<'EOF'
The [Buildpacks Community](http://buildpacks.io/community/) is always here to help. 

We can be found in our [discussion board][discussion-board] or [slack][slack] (`#buildpacks-tekton`).

[discussion-board]: https://github.com/buildpacks/community/discussions
[slack]: https://slack.cncf.io
EOF
)

export CONTRIBUTING=$(cat <<EOF
We ❤ contributions.

This ${TYPE} is maintained at [buildpacks/tekton-integration](https://github.com/buildpacks/tekton-integration). Issues, pull requests and other contributions can be made there. 

To learn more, read the [CONTRIBUTING][contributing] and [DEVELOPMENT][development] documents.

[contributing]: https://github.com/buildpacks/.github/blob/main/CONTRIBUTING.md
[development]: https://github.com/buildpacks/tekton-integration/blob/main/DEVELOPMENT.md
EOF
)

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
BUILDERS=$(echo -e  "$BUILDERS")
export BUILDERS=$(cat <<EOF
_The following are the suggested [builders][builders] from the [Cloud Native Buildpacks][buildpacks-io] project. This is only a subset of builders available._

$BUILDERS

[builders]: (https://buildpacks.io/docs/concepts/components/builder/)
[buildpacks-io]: (https://buildpacks.io)
EOF
)

DOCS_FILE="${RESOURCE_DIR}/README.md"
echo "> Writing docs to: ${DOCS_FILE}"
envsubst < "$TEMPLATE_FILE" > "$DOCS_FILE"

cat "$DOCS_FILE"