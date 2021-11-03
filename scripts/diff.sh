#!/usr/bin/env bash

set -e

# IMPORTS

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/_common.sh"

# CONFIGURATION

DIFFCMD=$(env_or_default DIFFCMD "git diff --no-index")

# DEPENDENCIES

require_command git
require_command $DIFFCMD

# FUNCTIONS

function diff_resources() {
    type=$1
    resources_dir=$2
    resources=${@:3}
    for a in $resources; do
        parts=(${a//:/ })
        if [ ${#parts[@]} != 2 ];then
            echo "Couldn't parse '${a}'. Make sure to provide a version (ie. 'my-${type}:0.2')"
            exit 2
        fi

        new_resource_dir="${resources_dir}/${parts[0]}/${parts[1]}"
        echo "> Diffing $type '${parts[0]}/${parts[1]}'..."
        old_resource_dir=$(find "${tmp_dir}/${type}/${parts[0]}" -maxdepth 1 -type d | sort | tail -1)
        $DIFFCMD "${old_resource_dir}" "${new_resource_dir}" || true
        echo
        echo
    done
}

# TASK

tmp_dir=$(create_tmpdir diff)

echo "> Downloading catalog..."
git clone https://github.com/tektoncd/catalog ${tmp_dir}

tasks_dir="${DIR}/../task"
tasks=$(get_tasks ${tasks_dir})
diff_resources "task" $tasks_dir $tasks

pipelines_dir="${DIR}/../pipeline"
pipelines=$(get_pipelines ${pipelines_dir})
diff_resources "pipeline" $pipelines_dir $pipelines
