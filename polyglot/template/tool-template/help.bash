#!/usr/bin/env bash
set -o nounset
set -o pipefail

source "$POLY_SRC/lib/lib-util.bash"

is-help-flag "${@: -1}"
case "$?" in
    1)
        echo "Tool: {template}

A Help command for the tool template.
"
        exit 2
    ;;
    *) ;;
esac
