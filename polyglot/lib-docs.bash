#!/usr/bin/env bash

function run_mdbook () {
    subhead "Building Mdbook"
    mdbook build
}

function run_sphinx () {
    subhead "[python] Building Sphinx"
    local CONF_DIR="$SRC_DIR/_sphinx"
    local SPHINX_OUT="$DOC_OUT/sphinx"

    echo "- config location: ${CONF_DIR}"
    echo "- out location: ${SPHINX_OUT}"
    echo "- builder: ${SPHINX_BUILDER}"
    echo ""

    if [[ -d "${SPHINX_OUT}" ]]; then
        rm -r "${SPHINX_OUT}"
    fi

    uv run --frozen sphinx-build \
        --verbose \
        --write-all \
        --fresh-env \
        --conf-dir "$CONF_DIR" \
        --doctree-dir "$SPHINX_OUT/.doctrees" \
        --warning-file "$LOG_DIR/sphinx.log" \
        --builder "$SPHINX_BUILDER" \
        "$SRC_DIR" \
        "$SPHINX_OUT"
        # || fail "Sphinx Failed"
}

function run_rustdoc () {
    subhead "[rust] Building Rustdoc"
    cargo doc \
        --workspace \
        --target-dir "$DOC_OUT/rustdoc"
}

function run_exdoc () {
    subhead "[elixir] Building ExDoc"
    mix docs --output "$DOC_OUT/elixir"
}

function run_docfx () {
    subhead "[dotnet] Running docfx"

    }

function run_doxygen () {
    subhead "[general] Running Doxygen"
    echo "TODO"
    }

function run_dokka () {
    subhead "[kotlin] Running Dokka"
    echo "TODO"

    }

# Tex  --------------------------------------------------
function run_tex () {
    header "[tex] Lualatex Compilation"
    for i in $(seq 1 "$PASSES"); do
        _luatex_pass "$i"
    done
    case "$TEX_USE_BIBTEX" in
        1)
            _bibtex_pass $((++i))
            _luatex_pass $((++i))
            _luatex_pass $((++i))
            ;;
        *)
            ;;

    esac
    header "Finished Tex Compilation to $TEX_OUT"
    exit 0
}

function _luatex_pass () {
    # Takes 1 arg: The pass number. the rest arg global args
    subhead "Pass $1: LuaLaTeX Compiling $TEX_TARGET in $TEX_TARGET_DIR"
    pushd "$TEX_TARGET_DIR" || fail "lualatex pass failed to pushd"
    declare -a ARGS=(
    "--lua=$TEX_LUA_FILE"
    "-interaction=nonstopmode"
    "--output-directory=$TEX_OUT"
    )

    case "$VERBOSE" in
        0)
            echo "..."
            lualatex "${ARGS[@]}" "${TEX_TARGET}.tex" > /dev/null || echo "Pass Exit Value: $?"
            ;;
        *)
            lualatex "${ARGS[@]}" "${TEX_TARGET}.tex" || echo "Pass Exit Value: $?"
            ;;
    esac
    popd || fail "lualatex pass failed to popd"
}

function _bibtex_pass () {
    subhead "Pass $1: Bibtex $TEX_TARGET in $TEX_OUT"
    pushd "$TEX_OUT" || fail "bibtex pass failed to pushd"
    case "$VERBOSE" in
        0)
            BIBINPUTS="$TARGET_DIR:$DATA_DIR:${BIBINPUTS:-}" bibtex "$TEX_TARGET" > /dev/null
            ;;
        *)
            BIBINPUTS="$TARGET_DIR:${BIBINPUTS:-}" bibtex "$TEX_TARGET"
            ;;
    esac
    popd || fail "bibtex pass failed to popd"
}

function find_tex_file () {
    # Takes 1 or 0 args
    local tex_target_base
    local tex_rel_dir

    TEX_TARGET_FILE=$(fdfind \
        --full-path \
        --extension ".tex" \
        --base-directory "$SRC_DIR" \
        --max-results 1 \
        "${1:-main.tex}" )

    if [[ -z "$TEX_TARGET_FILE" ]]; then
        fail "Could not find a tex target file"
    fi
    tex_rel_base=$(dirname "$TEX_TARGET_FILE")
    tex_target_base=$(basename "$TARGET_FILE" ".tex")
    TEX_TARGET_DIR="$SRC_DIR/$tex_rel_base"
}

# Main Access point: --------------------------------------------------

function pg_docs () {
    # Takes N args.
    header "Building Docs"
    local _sphinx=0
    local _mdbook=0
    local _rustdoc=0
    local _exdoc=0
    local _dotnet=0
    local _doxygen=0

    local LOOP_ARGS=("$@")
    if [[ ${#LOOP_ARGS[@]} -eq 1 ]] && [[ ${LOOP_ARGS[0]} = "--all" ]]; then
        LOOP_ARGS=( --book --sphinx --rust --elixir --dotnet --doxy --kotlin )
    fi

    for key in "${LOOP_ARGS[@]}"
        do
            case "$key" in
                -h|--help)
                    echo "Doc Builder Utility"
                    echo ""
                    echo "-a | --all : run all available doc builders"
                    echo ""
                    echo "--book    : run mdbook"
                    echo "--sphinx  : run sphinx"
                    echo "--rust    : run rustdoc"
                    echo "--elixir  : run ex_doc"
                    echo "--dotnet  : run dotnet's docfx"
                    echo "--kotlin  : run kotlin's dokka"
                    echo "--doxy    : run doxygen"
                    ;;
                --book) _mdbook=1 ;;
                --sphinx)
                    run_sphinx
                    ;;
                --rust)
                    run_rustdoc
                    ;;
                --elixir)
                    run_exdoc
                    ;;
                --dotnet)
                    run_docfx
                    ;;
                --doxy)
                    run_doxygen
                    ;;
                --kotlin)
                    run_dokka
                    ;;
                *)
                    echo "WARNING: unrecognized arg: $1"
                    ;;
            esac
    done

    if ((0 < _mdbook)); then
        # Always run mdbook last, as a general access point for anything else
        run_mdbook
        # if [[ -L "$DOC_OUT/index.html" ]]; then
        #     unlink "$DOC_OUT/index.html"
        # fi
        # ln -L -s "$DOC_OUT/book/index.html" "$DOC_OUT/index.html"
    fi
}

function pg_tex () {
    # takes maybe 1 arg: the target tex file name
    header "Running Tex"
    # set tex global vars
    find_tex_file "$1"
    run_tex
}
