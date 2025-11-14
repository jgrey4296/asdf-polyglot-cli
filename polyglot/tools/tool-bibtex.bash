#!/usr/bin/env bash

function run_bibtex () {
    subhead "Pass $1: Bibtex $TEX_TARGET in $TEX_OUT"
    pushd "$TEX_OUT" || fail "bibtex pass failed to pushd"
    case "$VERBOSE" in
        0)
            BIBINPUTS="$TARGET_DIR:$DATA_DIR:${BIBINPUTS:-}" bibtex "$TEX_TARGET" > /dev/null
            ;;
        *)
            BIBINPUTS="$TARGET_DIR:${BIBINPUTS:-}" bibtex "$TEX_TARGET"
            ;;
    esac
    popd || fail "bibtex pass failed to popd"
}
