#!/usr/bin/env bash


function run_doxygen () {
    if [[ ! -e "$POLYGLOT_ROOT/.doxygen" ]]; then
        echo "NOT FOUND: $POLYGLOT_ROOT/.doxygen"
        return
    fi
    subhead "[general] Running Doxygen"
    echo "TODO"
    # doxgen "$POLYGLOT_ROOT/.doxygen"
    exit 1
    }
