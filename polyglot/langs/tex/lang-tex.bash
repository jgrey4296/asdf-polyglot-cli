#!/usr/bin/env bash


function init_tex () {
    if [[ -f "$POLYGLOT_ROOT/tex.reqs" ]]; then
        tdot "Initialising Tex"
        mkdir -p "$TEX_OUT"
        asdf cmd texlive deps "$POLYGLOT_ROOT/tex.reqs" > /dev/null
    fi
}

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

function find_tex_file () {
    # Takes 1 or 0 args
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
    # tex_target_base=$(basename "$TARGET_FILE" ".tex")
    TEX_TARGET_DIR="$SRC_DIR/$tex_rel_base"
}

function build_tex () {
    # takes maybe 1 arg: the target tex file name
    header "Running Tex"
    # set tex global vars
    find_tex_file "$1"
    run_tex
}

function export_tex_deps () {
    tdot "Exporting Tex libraries"
    asdf cmd texlive reqs
}
