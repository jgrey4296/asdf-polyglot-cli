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

function install_dokka () {
    echo "TODO"
    # https://kotlinlang.org/docs/dokka-cli.html#generate-documentation
    exit 1
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


# TODO : new -------------------------------------------
# commands to add a new module to the workspace

function new_py () {
    echo "TODO"
    exit 1
}
function new_rust () {
    echo "TODO"
    exit 1
}
function new_kotlin() {
    echo "TODO"
    exit 1
}
function new_prolog () {
    echo "TODO"
    exit 1
}
function new_ansprolog () {
    echo "TODO"
    exit 1
}
function new_elixir () {
    echo "TODO"
    exit 1
}
function new_dotnet () {
    echo "TODO"
    exit 1
}
function new_godot () {
    echo "TODO"
    exit 1
}
function new_lisp () {
    echo "TODO"
    exit 1
}
function new_lua () {
    echo "TODO"
    exit 1
}
function new_csound () {
    echo "TODO"
    exit 1
}
function new_inform () {
    echo "TODO"
    exit 1
}

# TODO add deps  --------------------------------------------------

function add_py () {
    echo "TODO"
    # uv add
    exit 1
}
function add_rust () {
    echo "TODO"
    # cargo add
    exit 1
}
function add_kotlin () {
    echo "TODO"
    exit 1
}
function add_dotnet () {
    echo "TODO"
    # dotnet nuget add
    exit 1
}
function add_elixir () {
    echo "TODO"
    # add into mix.exs deps
    exit 1
}
function add_texlive () {
    echo "TODO"
    # tlmgr install
    exit 1
}
function add_lisp () {
    echo "TODO"
    exit 1
}
function add_lua () {
    echo "TODO"
    exit 1
}
function add_csound () {
    echo "TODO"
    exit 1
}
function add_inform () {
    echo "TODO"
    exit 1
}
function add_py () {
    echo "TODO"
    exit 1
}
