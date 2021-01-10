#!/usr/bin/env bash

function require_command() {
    if ! [ -x "$(command -v ${1})" ]; then
        echo 'Error: ${1} is not installed.' >&2
        exit 1
    fi
}