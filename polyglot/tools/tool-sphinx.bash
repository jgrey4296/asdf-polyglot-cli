#!/usr/bin/env bash

function run_sphinx_doc () {
    if [[ ! -e "$SPHINX_CONF_DIR/conf.py" ]]; then
        echo "NOT FOUND: $SPHINX_CONF_DIR/conf.py"
        return
    fi
    subhead "[python] Building Sphinx"

    echo "- config location: ${SPHINX_CONF_DIR}"
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
        --conf-dir "$SPHINX_CONF_DIR" \
        --doctree-dir "$SPHINX_OUT/.doctrees" \
        --warning-file "$LOG_DIR/sphinx.log" \
        --builder "$SPHINX_BUILDER" \
        "$SRC_DIR" \
        "$SPHINX_OUT"
        # || fail "Sphinx Failed"
}
