#!/usr/bin/env bash

function install_docfx () {
    header "TODO: install docfx"
    dotnet tool update -g docfx

}

function run_docfx () {
    if [[ ! -e "$POLYGLOT_ROOT/docfx.json" ]]; then
        echo "NOT FOUND: $POLYGLOT_ROOT/docfx.json"
        return
    fi
    subhead "[dotnet] Running docfx"
    docfx "$POLYGLOT_ROOT/docfx.json"
    }
