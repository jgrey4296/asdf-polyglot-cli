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
    if [ "${VERBOSE:-0}" -eq 1 ]; then
        echo "$@"
    fi
}

function fail () {
    echo -e "Failed: ${*}"
    exit 1
}

function header () {
    [[ -z "${POLYGLOT_SUPPRESS_HEADER:-}" ]] || return
    echo -e "${HEADER_PREFIX} ${HEADER_LINE}\n${HEADER_PREFIX} ${*}\n${HEADER_PREFIX} ${HEADER_LINE}"

}

function subhead () {
    if [[ -n "${POLY_CTX:-}" ]]; then
        echo -e "[${POLY_CTX/^\./}] $SUBHEAD_LINE ${*}"
    else
        echo -e "$SUBHEAD_LINE ${*}"
    fi
}

function tdot () {
    local ctx=$(pushctx "$1")
    shift
    echo -e "[$ctx] $TDOT_LINE ${*}"
}

function pctx () {
    echo -e "[$POLY_CTX] $TDOT_LINE ${*}"
}

function sep () {
    echo "-------------------------"
}

function is-help-flag () {
    # returns 1 if --help or -h is passed in
    case "$1" in
        -h|--help) return 1 ;;
        *) return 0 ;;
    esac
}

function check-target () {
    if [[ ! -d "$POLYGLOT_SRC/$1" ]]; then
        fail "Target Does not exist: $1"
    fi

    if [[ ! -e "$POLYGLOT_SRC/$1/$2" ]]; then
        fail "Target does not have a file to run: $2"
    fi
}

function subcmd-exists-check () {
    # 1:path to dir to check for subcmd
    # 2:subcmd
    [[ -d "$1" ]] || fail "Subcmd dir does not exist: $1"
    [[ -n "${2:-}" ]] || fail "No subcmd provided for check"
    local possible
    readarray -d '' possible < <(find "$1" -name "${2}*" -a -executable -print0)
    [[ "${#possible[@]}" -gt 0 ]] || return 1
    [[ "${#possible[@]}" -lt 2 ]] || fail "Too Many Possible Subcmds Found: ${#possible[@]}"
    return 0
}

function subcmd-run () {
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
