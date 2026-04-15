#!/usr/bin/env bash
# lib-logging.bash -*- mode: sh -*-
#set -o errexit
set -o nounset
set -o pipefail

function print-version () {
    case "${@: -1}" in
        -v|--version) echo "$POLYGLOT_VERSION" && exit 0 ;;
    esac
}

function debug () {
    # A Debug message when the VERBOSE envar is set
    [[ "${VERBOSE:-0}" -eq 0 ]] || echo -e "$@"
}

function fail () {
    # message and force quit
    echo -e "Failed: ${*}"
    exit 1
}

function header () {
    # Print lines passed in, wrapped.
    [[ -z "${POLYGLOT_SUPPRESS_HEADER:-}" ]] || return
    echo "$HEADER_PREFIX $HEADER_LINE"
    for line in "$@"
    do
        echo -e "${HEADER_PREFIX} ${line}"
    done
    echo "$HEADER_PREFIX $HEADER_LINE"
}

function subhead () {
    # print a subheader
    if [[ -n "${POLY_CTX:-}" ]]; then
        echo -e "[${POLY_CTX/^\./}] $SUBHEAD_LINE ${*}"
    else
        echo -e "$SUBHEAD_LINE ${*}"
    fi
}

function tdot () {
    # print a message of form [$1] ... $rest
    local ctx
    ctx=$(pushctx "$1")
    shift
    echo -e "[$ctx] $TDOT_LINE ${*}"
}

function sep () {
    # print a separating line
    echo "$HEADER_LINE"
}

function pctx () {
    # print a message of form: [{ctxEnvVar}] ... {msg}
    echo -e "[${POLY_CTX:-}] $TDOT_LINE ${*}"
}

function pushctx () {
    # Add info the POLY_CTX (for pctx printing)
    local ctx
    if [[ -n "${POLY_CTX:-}" ]] && [[ -n "$1" ]]; then
        ctx="${POLY_CTX}.$1"
    elif [[ -z "$1" ]]; then
        ctx="$POLY_CTX"
    else
        ctx="$1"
    fi
    echo "$ctx"
}

function maybe-print-help () {
    # $1 : 0=root 1=branch 2=leaf
    # $2 : defer count
    # $3 : text
    # $@ : args
    local TYPE COUNT TEXT SHOULD_DEFER FLAG ACTIVE
    LEVEL="$1"
    COUNT="$2"
    TEXT="$3"
    shift 3
    FLAG=1
    ACTIVE=1

    case "${@: -1}" in
        -h|--help)
            FLAG=0
            shift
            ;;
    esac

    case "$LEVEL" in
        "root")
            [[ "$#" -eq 0 ]]
            ACTIVE="$?"
            # echo "root active"
            ;;
        "branch")
            { [[ "$#" -eq 0 ]] && [[ "$COUNT" -gt 0 ]]; } || { [[ "$#" -lt "$COUNT" ]] && [[ "$FLAG" -eq 0 ]]; }
            ACTIVE="$?"
            # echo "branch active"
            ;;
        "leaf")
            { [[ "$#" -eq 0 ]] && [[ "$COUNT" -gt 0 ]]; } || [[ "$FLAG" -eq 0 ]]
            ACTIVE="$?"
            # echo "leaf active"
            ;;
    esac

    if [[ "$ACTIVE" -eq 0 ]]; then
        echo -e "$TEXT"
        exit "$PRINTED_HELP"
    fi

}

function print-env-failures() {
    # $1 : failure array
    declare -a fail_array=("$@")
    if [[ -n "${fail_array:-}" ]] && [[ "${#fail_array[@]}" -gt 0 ]]; then
        pctx "Missing Env vars:"
        for val in "${fail_array[@]}"
        do
            echo "- $val"
        done
        fail "Environment Is Not Correct"
    fi
}
