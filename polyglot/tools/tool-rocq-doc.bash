#!/usr/bin/env bash


function run_rocq_doc () {
    if [[ ! -e "$POLYGLOT_ROOT/_CoqProject" ]]; then
        echo "NOT FOUND: $POLYGLOT_ROOT/_CoqProject"
        return
    fi
    subhead "[rocq] Running Doc"
    # https://rocq-prover.org/doc/V9.0.0/refman/using/tools/coqdoc.html
    echo "TODO"
    # rocq doc --HTML --LaTeX -d "$DOC_OUT/rocq"
    exit 1
}
