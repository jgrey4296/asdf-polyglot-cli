#!/usr/bin/env bash

function init_dotnet() {
    if [[ -z $(fdfind "\.sln" "$POLYGLOT_ROOT") ]]; then
        echo "Creating new sln"
        dotnet new sln
    fi
}

function add_sub_dotnet () {
    # must be run sequentially
    fdfind ".(cs|fs)proj" "$POLYGLOT_ROOT" --threads=1 --exec dotnet sln add
}
