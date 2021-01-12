#!/usr/bin/env bash

set -e

# IMPORTS

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/_common.sh"

# DEPENDENCIES

require_command kubectl
require_command git

# INPUT

if [ "$1" = "" ];then
  echo "Usage: ${BASH_SOURCE[0]} <task-name:version>..."
  exit 1
fi

# TASK

tmp_dir=/tmp/test-$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-z0-9' | fold -w 10 | head -n 1)

echo "> Downloading catalog..."
git clone https://github.com/tektoncd/catalog ${tmp_dir}

echo "> Coping/Overlaying dev tasks..."
cp -vR ${DIR}/../tasks/ ${tmp_dir}/task/

pushd ${tmp_dir} > /dev/null

    for a in "$@"; do
        parts=(${a//:/ })
        if [ ${#parts[@]} != 2 ];then
            echo "Couldn't parse '${a}'. Make sure to provide a version (ie. 'my-task:0.2')"
            exit 2
        fi
        ./test/run-test.sh ${parts[0]} ${parts[1]}
    done

popd > /dev/null