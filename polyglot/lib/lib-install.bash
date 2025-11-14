#!/usr/bin/env bash
# Install scripts for various tooling for polyglot

# init --------------------------------------------------


function init_asdf () {
    local words
    # asdf plugin add
    if [[ -e "$ASDF_PLUGIN_LIST" ]]; then
        tdot "Initialising extra asdf plugins"
        while read -r pname url; do
            if [[ -n "$pname" ]]; then
                asdf plugin add "${pname}" "${url}" 2> /dev/null
            fi
        done < "$ASDF_PLUGIN_LIST"
    fi
    asdf install 2> /dev/null
}

function init_precommit () {
    if [[ -e "$POLYGLOT_ROOT/.pre-commit-config.yaml" ]]; then
        tdot "Installing pre-commit hooks"
        pre-commit install
    fi
}
