#!/usr/bin/env bash
# lib-runners.bash -*- mode: sh -*-
#set -o errexit
set -o nounset
set -o pipefail

function subcmd-run () {
    # Run all subcmds that match the target
    # shifts the first 2 args, passes rest to the subcmd
    local possible base target
    subcmd-exists-check "$@" || fail "No applicable subcmds found"
    base=$(poly-dir)
    target="$1"
    subcmd="$2"
    shift 2
    cmd_path="${base}/${target}"
    readarray -d '' possible < <(find "$cmd_path" -name "${target}*" -a -executable -print0)
    sub="${possible[1]}"
    if [[ -x "$sub" ]]; then
        POLY_SRC="$POLY_SRC" "$sub" "$@"
        return "$?"
    else
        fail "Not Executable: $sub"
    fi
}

function run-tool-subcmd () {
    # Run a tool's subcmd
    # run-tool-subcmd {subcmd} {args}
    local tool="$1"
    local subcmd="$2"
    shift 2
    if [[ -d "$(poly-dir)/tools/${tool}" ]]; then
        subcmd-run "tools/${tool}" "$subcmd" "$@"
        return "$?"
    elif [[ -d "$(poly-dir)/tool-${tool}"  ]]; then
        subcmd-run "tool-${tool}" "$subcmd" "$@"
        return "$?"
    fi
    fail "Couldn't find a tool subcmd to run"
}

function run-lang-subcmd () {
    # Run a lang subcmd
    local lang="$1"
    local subcmd="$1"
    shift 2

    [[ -n "$target" ]] || fail "No Applicable language subcommand specified"
    debug "- Checking for subcommand ${prefix}-$lang: $target"

    if [[ -d "$(poly-dir)/${prefix}-${lang}" ]]; then
        subcmd-run "langs/${lang}" "$subcmd" "$@"
        return "$?"
    elif [[ -d "$base/lang-${lang}" ]]; then
        subcmd-run "$lang-${lang}" "$subcmd" "$@"
        return "$?"
    fi
    fail "Couldn't find a lang subcmd to run"
}

function run-task () {
    # Run the hooks of a task
    # run-hooks {dry} {task} {args}
    # task is of the form task-{}
    local base count ctx target
    local dry="$1"
    local task="$2"
    shift 2
    base=$(poly-dir)
    count=0
    if [[ -d "$(poly-dir)/tasks/${task}" ]]; then
        target="$(poly-dir)/tasks/${task}"
    elif [[ -d "$(poly-dir)task-${task}" ]]; then
        target="$(poly-dir)/task-${task}"
    fi


    for hook in $(find "${target}" -executable -a -type f | sort -V)
    do
        hname=$( basename "$hook" )
        ctx=$(pushctx "$task")

        if [[ "$dry" -gt 0 ]]; then
            subhead "(dry) $hname ${*}"
        else
            [[ -z "${VERBOSE:-}" ]] || subhead "Hook: $(basename $hook)"
            (
                POLY_SRC="$POLY_SRC" \
                POLY_HOOK="$count" \
                POLY_CTX="$ctx" \
                "$hook" "$@"
            )
        fi
        case "$?" in
            0) # Normal hook completion
                debug "- Hook Success"
            ;;
            1) # Hook Failed
                fail "$(basename "$hook")"
            ;;
            "${PRINTED_HELP}") # Hook Printed Help
                return 0
            ;;
            *) # Unknown result
                fail "Unknown Result: ($?) : $task/""$(basename "$hook")"
            ;;
        esac
        count=$(( 1 + count ))
    done

    header "Finished: $task. ($count) hooks ran."
    return 0
}

function run-task-nth-hook () {
    local base="$1"
    local prefix="$2"
    local nth="$3"
    local task="$4"
    shift 4
    local count=0
    echo -e "Running hook ($nth) with ($#) args: ${*} "

    for hook in $(find "$base/${prefix}-${task}" -executable -a -type f | sort -V)
    do
        hname=$( basename "$hook" )
        if [[ "$nth" = "$count" ]]; then
            subhead "Running hook $count: $hname"
            (
                POLY_SRC="$POLY_SRC" \
                    POLY_HOOK="$count" \
                    "$hook" "$@"
            )
            subhead "Skipping remaining hooks"
            exit 0
        else
            subhead "Skipping hook $count: $hname"
            count=$(( 1 + count ))
        fi
    done
    exit 0
}

function run-free-cmds () {
    # early override for when you aren't in a workspace,
    # and want one.
    print-version "$@"
    local cmdname="$1"
    shift
    case "$cmdname" in
        new)
            # shellcheck disable=SC2097,SC2098
            POLY_SRC="$POLY_SRC" polyglot-new "$@"
            exit "$?" ;;
        env)
            POLY_SRC="$POLY_SRC" polyglot-env "$@"
            exit "$?" ;;
        -h|--help|help)
            POLY_SRC="$POLY_SRC" polyglot-help "$@"
            exit "$?"
            ;;
        *) ;;
    esac
}
