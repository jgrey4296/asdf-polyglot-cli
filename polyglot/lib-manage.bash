#!/usr/bin/env bash
# lib-manage.bash -*- mode: sh -*-

current_script_path="${BASH_SOURCE[0]}"
toml_template=$(realpath "$(dirname "$current_script_path")")/polyglot.template

function pg_manage_init () {
    echo "initialise a polyglot.toml file"
    cp "$toml_template" "$POLY_SRC"

}

function pg_manage_locate () {
    echo "TODO: look up to find a polyglot.toml file"

}

function pg_manage_add () {
    echo "TODO: add a languages settings files"

}

function pg_manage_remove () {
    echo "TODO: remove a languages settings files"
}

function pg_manage_clean () {
    echo "TODO: remove unused language settings files"

}

function pg_manage_validate () {
    echo "TODO: validate the polyglot.toml file"
}

function pg_manage_checklist () {
    echo "TODO: checklist"
}


function pg_manage_regenerate () {
    echo "TODO: regenerate"

    # cargo install --list > .cargo.tools
    # tex.reqs
    #
}
