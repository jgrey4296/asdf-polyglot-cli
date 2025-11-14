#!/usr/bin/env bash


function run_mdbook () {
    if [[ ! -e "$POLYGLOT_ROOT/book.toml" ]]; then
        echo "NOT FOUND: $POLYGLOT_ROOT/book.toml"
        return
    fi

    subhead "Building Mdbook"
    mdbook build
}
