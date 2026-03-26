#!/usr/bin/env bash
# Utilities for polyglot
# shellcheck disable=SC2034
NOTHING=50
PRINTED_HELP=2

HEADER_PREFIX="|| *"
HEADER_LINE="------------------------------"
SUBHEAD_LINE="----------"
TDOT_LINE="..."

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

function pctx () {
    # print a message of form: [{ctxEnvVar}] ... {msg}
    echo -e "[${POLY_CTX:-}] $TDOT_LINE ${*}"
}

function sep () {
    # print a separating line
    echo "$HEADER_LINE"
}

function check-target () {
    # Check a target task/tool exists, and the hook/op is executable
    [[ -d "$POLYGLOT_SRC/$1" ]]    || fail "Target Does not exist: $1"
    [[ -e "$POLYGLOT_SRC/$1/$2" ]] || fail "Target does not have a file to run: $2"
}

function subcmd-exists-check () {
    # Test for a polyglot subcmd
    # 1:path to dir to check for subcmd
    # 2:subcmd
    [[ -d "$1" ]]     || fail "Subcmd dir does not exist: $1"
    [[ -n "${2:-}" ]] || fail "No subcmd provided for check"
    local possible
    readarray -d '' possible < <(find "$1" -name "${2}*" -a -executable -print0)
    [[ "${#possible[@]}" -gt 0 ]] || return 1
    [[ "${#possible[@]}" -lt 2 ]] || fail "Too Many Possible Subcmds Found: ${#possible[@]}"
    return 0
}

function subcmd-run () {
    # Run a verified polyglot subcmd
    subcmd-exists-check "$@" || fail "No applicable subcmds found"
    local possible
    readarray -d '' possible < <(find "$1" -name "${2}*" -a -executable -print0)
    sub="${possible[0]}"
    if [[ -x "$sub" ]]; then
        POLY_SRC="$POLY_SRC" "$sub" "$@"
        return "$?"
    else
        fail "Not Executable: $sub"
    fi
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

function list-entries () {
    # List the available hooks/ops in a target path
    # $1 : directory to search, eg: $polyglot_root/.tasks
    # $2 : the tool/task to list
    local target_path="$1"
    shift
    case "${1:-}" in
        "") target_path="$target_path/" ;;
        lang|tool|task)
            target_path="$target_path/$1-"
        ;;
        *) ;;
    esac
    shift
    case "${1:-}" in
        "") ;;
        *) target_path="${target_path}${1}/" ;;
    esac

    for val in "$target_path"*
    do
        basename "$val"
    done
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
            echo "root acctive"
            ;;
        "branch")
            { [[ "$#" -eq 0 ]] && [[ "$COUNT" -gt 0 ]]; } || { [[ "$#" -lt "$COUNT" ]] && [[ "$FLAG" -eq 0 ]]; }
            ACTIVE="$?"
            echo "branch active"
            ;;
        "leaf")
            { [[ "$#" -eq 0 ]] && [[ "$COUNT" -gt 0 ]]; } || [[ "$FLAG" -eq 0 ]]
            ACTIVE="$?"
            echo "leaf active"
            ;;
    esac

    if [[ "$ACTIVE" -eq 0 ]]; then
        echo -e "$TEXT"
        exit "$PRINTED_HELP"
    fi

}

function print-help () {
    # DEPRECATED, use maybe-print-help
    # test args, if the last one is -h or --help
    # print help and exit
    # $1 : help text
    # $2 : min count of cmd args
    # $rest : args passed to cmd
    local HELP_TEXT MIN_COUNT
    HELP_TEXT="$1"
    MIN_COUNT="$2"
    shift 2
    case "${@: -1}" in
        -h|--help) ;;
        *) [[ "$#" -ge "$MIN_COUNT" ]] && return ;;
    esac
    echo -e "$HELP_TEXT"
    exit "${PRINTED_HELP}"
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
