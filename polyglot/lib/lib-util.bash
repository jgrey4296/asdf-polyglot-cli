#!/usr/bin/env bash
# Utilities for polyglot
# shellcheck disable=SC2034

function check-target () {
    # Check a target task/tool exists, and the hook/op is executable
    [[ -d "$POLYGLOT_SRC/$1" ]]    || fail "Target Does not exist: $1"
    [[ -e "$POLYGLOT_SRC/$1/$2" ]] || fail "Target does not have a file to run: $2"
}

function subcmd-exists-check () {
    # Test for a polyglot subcmd
    # 1:path to dir to check for subcmd
    # 2:subcmd
    # Returns: 0 if subcmd exists, 1 if subcmd doesnt, N if there are more than one subcmds
    [[ -d "$1" ]]     || fail "Subcmd dir does not exist: $1"
    [[ -n "${2:-}" ]] || fail "No subcmd provided for check"
    local possible
    readarray -d '' possible < <(find "$1" -name "${2}*" -a -executable -print0)
    [[ "${#possible[@]}" -gt 0 ]] || return 1
    [[ "${#possible[@]}" -lt 2 ]] || fail "Too Many Possible Subcmds Found: ${#possible[@]}"
    return 0
}

function list-entries () {
    # List the available hooks/ops in a target path
    # $1 : directory to search, eg: $polyglot_root/.tasks
    # $2 : the type to list
    # #3 : the specific target to list
    local target_path
    local base_path="${1:-}"
    local target="${2:-}"
    local filter="${3:-}"
    shift
    case "$target" in
        "")                target_path="$base_path/"    ;;
        lang-|tool-|task-) target_path="$base_path/$1-" ;;
        lang|tool|task)    target_path="$base_path/${1}s/" ;;
        *) ;;
    esac
    shift
    case "$filter" in
        "") ;;
        *) target_path="${target_path}${1}/" ;;
    esac

    for val in "$target_path"*
    do
        basename "$val"
    done
}
