#!/usr/bin/env bash

# TODO dry-run flag
function run-cmd () {
    # run-cmd {basedir} {subcmd}
    # task is of the form lang-{sub} or tool-{sub}
    local base="$1"
    local prefix="$2"
    local task="${3:-}"
    shift 3
    local count=0
    debug "- Checking for command ${prefix/-/}: $task"
    if [[ ! -x "$base/$prefix$task" ]] && [[ ! -d "$base/$prefix$task" ]]; then
        return $NOTHING
    fi

    if [[ -d "$base/$prefix$task" ]]; then
        debug "Found a Directory"
        # check for next arg in the dir
        run-subcmd "$base/$prefix$task" "" "$@"
        return 0
    elif [[ -x "$base/$prefix$task" ]]; then
        POLY_SRC="$POLY_SRC" "$base/$prefix$task" "$@"
        return
    fi
    return $NOTHING
}

function run-subcmd () {
    # run-subcmd {basedir} {subcmd} {args}
    # task is of the form lang-{sub} or tool-{sub}
    local base="$1"
    local prefix="$2"
    local task="${3:-}"
    local target="${4:-}"
    shift 3
    local count=0
    if [[ -z "$target" ]]; then
        return $NOTHING
    fi

    debug "- Checking for subcommand ${prefix}$task: $target"
    if [[ ! -d "$base/$prefix$task" ]]; then
        return $NOTHING
    fi

    local possible
    readarray -d '' possible <(find "$base/${prefix}${tool}" -name "${target}*" -a -executable)
    if [[ "${#possible[@]}" -lt 1 ]]; then
        fail "No possible command found"
    elif [[ "${#possible[@]}" -gt 1 ]]; then
        fail "Too Many possible targets found: ${#possible[@]}"
    fi

    for sub in "$base/$prefix$task/$target"*
    do
        if [[ -x "$sub" ]]; then
            POLY_SRC="$POLY_SRC" "$sub" "$@"
            return
        fi
    done
    return $NOTHING
}
