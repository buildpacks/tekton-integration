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

# TASK

tmp_dir=$(create_tmpdir diff)

echo "> Downloading catalog..."
git clone https://github.com/tektoncd/catalog ${tmp_dir}

task_dir="${DIR}/../task"
tasks=$(get_tasks_to_test ${task_dir})

for a in $tasks; do
    parts=(${a//:/ })
    if [ ${#parts[@]} != 2 ];then
        echo "Couldn't parse '${a}'. Make sure to provide a version (ie. 'my-task:0.2')"
        exit 2
    fi

    new_task_dir="${task_dir}/${parts[0]}/${parts[1]}"
    echo "> Diffing task '${parts[0]}/${parts[1]}'..."
    old_task_dir=$(find "${tmp_dir}/task/${parts[0]}" -maxdepth 1 -type d | sort | tail -1)
    $DIFFCMD "${old_task_dir}" "${new_task_dir}" || true
    echo
    echo
done