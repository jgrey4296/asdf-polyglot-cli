#!/usr/bin/env bash
# Utilities for polyglot
NOTHING=50

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
    echo -e "... ${*}"
}

function sep () {
    echo "-------------------------"
}

function is-help-flag () {
    case "$1" in
        -h|--help) return 1 ;;
        *) return 0 ;;
    esac
}

