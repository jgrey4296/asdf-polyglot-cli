#!/usr/bin/env bash

function run_rust_doc () {
    if [[ ! -e "$POLYGLOT_ROOT/Cargo.toml" ]]; then
        echo "NOT FOUND: $POLYGLOT_ROOT/Cargo.toml"
        return
    fi
    subhead "[rust] Building Rustdoc"
    cargo doc \
        --workspace \
        --target-dir "$DOC_OUT/rustdoc"
}
