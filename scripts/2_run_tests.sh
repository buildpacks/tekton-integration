#!/usr/bin/env bash

set -e

# IMPORTS

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/_common.sh"

# DEPENDENCIES

require_command kubectl
require_command git

# TASK

tmp_dir=/tmp/test-$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-z0-9' | fold -w 10 | head -n 1)
git clone https://github.com/tektoncd/catalog ${tmp_dir}

pushd ${tmp_dir} > /dev/null

    ./test/run-test.sh buildpacks 0.2

popd > /dev/null