#!/usr/bin/env bash
NOTHING=50

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

        return
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

    local possible=( "$base/$prefix$task/$target"* )
    if [[ "${#possible[*]}" -gt 1 ]]; then
        fail "Too Many possible targets found: ${#possible[*]}"
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

function run-task () {
    # run-hooks {basedir} {task}
    # task is of the form task-{}
    local base="$1"
    local prefix="$2"
    local task="$3"
    shift 3
    local count=0
    debug "- Checking for ${prefix/-/}: $task"
    if [[ ! -d "$base/$prefix$task" ]]; then
        return $NOTHING
    fi
    debug "- Running $task"

    for hook in $(find "$base/$prefix$task" -executable -a -type f | sort -V)
    do
        (
            POLY_SRC="$POLY_SRC" \
            HOOK_NUM="$count" \
                "$hook" "$@"
        )
        case "$?" in
            0) # Normal hook completion
                # echo "- Success"
            ;;
            1) # Hook Failed
                fail "$(basename "$hook")"
            ;;
            2) # Hook Printed Help
                return 0
            ;;
            *) # Unknown result
                fail "Unknown Result: ($?) : $task/""$(basename "$hook")"
            ;;
        esac
        count=$(( 1 + count ))
        echo ""
    done

    header "Finished: $task. ($count) hooks ran."
    return 0
}
