#!/usr/bin/env bash

function init_py () {
    if [[ -d "$TEMP_DIR/venv" ]]; then
        return
    fi

    tdot "Initialising Python"
    uv venv
    uv sync --all-groups
}

function add_py_dep () {
    echo "TODO"
    # uv add
    exit 1
}

function new_sub_py () {
    exit 1
}

function start_py_repl () {

}

function run_py_lint () {
    # uv run ruff check --output-format concise
    # uv run mypy
    # uv run mypy --strict
    exit 1
}

function run_py_test () {
    # uv run pytest

    # uv run pytest \
    #     "--cov=$SRC_DIR" \
    #     "--cov-report=json" \
    #     "--cov-report=term" \
    #     "--cov-report=xml" \
    #     "--cov-report=html" \
    #     "--no-cov-on-fail" \
    exit 1
}

function make_py_toml_template () {
    echo '
[polyglot.python]
suffixes  = [".py"]
config    = ["pyproject.toml", "ruff.toml", "uv.lock"]
prefix    = "py_"
active    = []

'
}
