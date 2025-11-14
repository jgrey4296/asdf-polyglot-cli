#!/usr/bin/env bash

function run_dispy () {
    # 1 or 2 args: target, and out
    # https://docs.python.org/3/library/dis.html#command-line-interface
    header "Python Disassembly"
    local DIS_TARGET="$1"
    shift
    local DIS_OUT="$1"

    [[ -e "$DIS_TARGET" ]] || fail "Python Disassembly Target doesn't exist: $DIS_TARGET"

    if [[ -n "$DIS_OUT" ]]; then
        python -m dis "$DIS_TARGET"
    else
        python -m dis "$DIS_TARGET" > "$DIS_OUT"
    fi
}
