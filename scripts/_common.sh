function require_command() {
    if ! [ -x "$(command -v ${1})" ]; then
        echo "Error: '${1}' is not installed." >&2
        exit 1
    fi
}

function env_or_default() {
    if [ ! -z "${!1}" ]; then
        echo ${!1}
    else
        echo ${2}
    fi
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