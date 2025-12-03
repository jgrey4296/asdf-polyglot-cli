#!/usr/bin/env bash
# Utilities for polyglot
NOTHING=50
PRINTED_HELP=2

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
    echo -e "|-------------------------\n| * ${*}\n|-------------------------"
}

function subhead () {
    echo -e "---------- ${*}"
}

function tdot () {
    head="$1"
    shift
    echo -e "$1 ... ${*}"
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
