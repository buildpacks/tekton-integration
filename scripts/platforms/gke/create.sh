#!/usr/bin/env bash

set -e

# IMPORTS

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "${DIR}/../../_common.sh"

# DEPENDENCIES

require_command kubectl
require_command gcloud
require_command terraform

# INPUTS

if [ "$1" = "" ];then
    cluster_name="test-$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-z0-9' | fold -w 10 | head -n 1)"
else
    cluster_name=$1
fi

# TASK
pushd ${DIR} > /dev/null
    
    echo "> Creating cluster '${cluster_name}'..."
    terraform init
    terraform apply -var="cluster_name=${cluster_name}"

    echo "> Setting up kubectl context..."
    gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) \
        --region $(terraform output -raw region)
    
    echo "> Context: $(kubectl config current-context)"

popd > /dev/null
