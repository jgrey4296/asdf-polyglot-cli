#!/usr/bin/env bash
# Install scripts for various tooling for polyglot


function install_jvm () {
    # https://sdkman.io/install/
    if [[ -n "$SDKMAN_DIR" ]] && [[ -d  "$SDKMAN_DIR" ]]; then
        # shellcheck disable=SC1091
        source "$SDKMAN_DIR/bin/sdkman-init.sh"
    else
        header "Installing SDKMAN"
        curl -s "https://get.sdkman.io" | bash
        # shellcheck disable=SC1091
        source "$SDKMAN_DIR/bin/sdkman-init.sh"
        sep
    fi
}

function install_rocq () {
    header "TODO: install rocq"
}

function install_docfx () {
    header "TODO: install docfx"
    dotnet tool update -g docfx

}

# init --------------------------------------------------

function init_tex () {
    if [[ -f "$POLYGLOT_ROOT/tex.reqs" ]]; then
        tdot "Initialising Tex"
        mkdir -p "$TEX_OUT"
        asdf cmd texlive deps "$POLYGLOT_ROOT/tex.reqs" > /dev/null
    fi
}

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

function init_py () {
    if [[ -d "$TEMP_DIR/venv" ]]; then
        return
    fi

    tdot "Initialising Python"
    uv venv
    uv sync --all-groups
}

function init_precommit () {
    if [[ -e "$POLYGLOT_ROOT/.pre-commit-config.yaml" ]]; then
        tdot "Installing pre-commit hooks"
        pre-commit install
    fi
}

function init_polyglot () {
    header "Initialising Polyglot Project"
    mkdir -p "$TEMP_DIR"
    init_asdf
    init_py
    init_tex
    init_precommit
    echo "done."
}
