#!/usr/bin/env bash
# lib-helpers.bash -*- mode: sh -*-
#set -o errexit
set -o nounset
set -o pipefail


function poly-dir () {
    echo "${POLYGLOT_ROOT}/${POLYGLOT_DIR}"
}

function poly-list () {
    local base type fmt
    base=$(poly-dir)
    type="${1:-}"
    filter="${2:-}"
    fmt="${3:- }"
    readarray -t entries <<< $(list-entries "$base" "$type" "$filter" | sort)
    for val in "${entries[@]}"
    do
        case "$val" in
            "") ;;
            *) echo "${fmt}${val}"
               ;;
        esac
    done
    exit
}
