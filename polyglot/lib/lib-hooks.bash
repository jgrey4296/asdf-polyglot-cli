#!/usr/bin/env bash

function build-polyglot-env () {
    # augment the env with polyglot specific entries.
    # eg: POLYGLOT_LANG_PYTHON=1, POLYGLOT_LANG_RUST=0
    # for use to enable/disable hooks.
    fail "TODO"
}

function run-task-hooks () {
    # get all hooks in polyglot_root/.tasks/task-$1
    # sort by leading numeric priority
    # call all that are executable, in order
    # ignore hooks with leading _

    fail "TODO"
}

function run-lang-hook () {
    # look in polyglot_root/.tasks/lang-$1 for $2
    # if it exists and is executable, run it

    fail "TODO"
}

function run-took-hook () {
    # look in polyglot_root/.tasks/tool-$1 for $2
    # if it exists, and is executable, run it

    fail "TODO"

}
