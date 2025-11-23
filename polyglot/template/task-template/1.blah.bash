#!/usr/bin/env bash
#
# shellcheck disable=SC1091
source "$POLY_SRC/lib/lib-util.bash"

fname=$(basename "${BASH_SOURCE[0]}")
header "($HOOK_NUM): $fname.\n| Args: " "$@"

while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--target)
            echo "Target: $2"
            ;;
        --bloo=*)
            echo "Assignment: $1"
            IFS="=" read -ra KEYVAL <<< "$1"
            echo "Key: ${KEYVAL[0]/--/}"
            echo "Val: ${KEYVAL[1]}"
            ;;
        *) # Positional
            echo "Positional: $1"
            ;;
    esac
    shift
done

# echo "Calling polyglot within a hook"
# polyglot --help
