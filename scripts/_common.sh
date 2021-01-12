function require_command() {
    if ! [ -x "$(command -v ${1})" ]; then
        echo "Error: '${1}' is not installed." >&2
        exit 1
    fi
}

function get_kubectl_cmd() {
    if [ ! -z "${KUBECTL_CMD}" ]; then
        echo ${KUBECTL_CMD}
    else
        echo kubectl
    fi
}

function kubectl_cmd() {
    eval "$(get_kubectl_cmd) ${@:1}"
}

function get_tasks_to_test() {
    if [ ! -z "${TASKS}" ]; then
        parts=(${TASKS//;/ })
        echo "${parts[@]}"
    else
        tasks=()
        for t in $(find ${1} -depth 2 -type d); do
            parts=(${t//\// })
            tasks+=("${parts[-2]}:${parts[-1]}")
        done
        echo "${tasks[@]}"
    fi
}