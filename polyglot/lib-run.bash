#!/usr/bin/env bash
# Scripts for running aspects of the polyglot project

function run_godot () {
    header "TODO: Run Godot"
}

function run_prolog () {
    header "TODO: Run prolog"
    # https://www.swi-prolog.org/pldoc/man?section=cmdline
}

function run_ansprolog () {
    header "TODO: run ansprolog"
    # https://potassco.org/

}

function run_rocq () {
    header "TODO: run rocq"
    # https://rocq-prover.org/doc/V9.0.0/refman/practical-tools/utilities.html

    # rocq makefile -f _CoqProject -o CoqMakefile
    # make -f CoqMakefile
}

#  repls --------------------------------------------------
# TODO access points for repls

function run_repl () {
    # take 1 arg, the language
    echo "TODO"
    exit 1
}

#   --------------------------------------------------

function run_dispy () {
    # 1 or 2 args: target, and out
    # https://docs.python.org/3/library/dis.html#command-line-interface
    header "Python Disassembly"
    local DIS_TARGET="$1"
    shift
    local DIS_OUT="$1"

    [[ -e "$DIS_TARGET" ]] || fail "Python Disassembly Target doesn't exist: $DIS_TARGET"

    if [[ -n "$DIS_OUT" ]]; then
        python -m dis "$DIS_TARGET"
    else
        python -m dis "$DIS_TARGET" > "$DIS_OUT"
    fi
}

function run_lint () {
    header "TODO: lint"
    # uv run ruff check --output-format concise
    # uv run mypy
    # uv run mypy --strict
}

function run_test () {
    header "TODO: tests"
    # uv run pytest

    # uv run pytest \
    #     "--cov=$SRC_DIR" \
    #     "--cov-report=json" \
    #     "--cov-report=term" \
    #     "--cov-report=xml" \
    #     "--cov-report=html" \
    #     "--no-cov-on-fail" \

    # - kotlin / gradle
    # - elixir / mix
}

# android keystore --------------------------------------------
function run_keystore () {
    # up to 2 args. 'new' and the name of the keystore file
    case $1 in
        new)
            KEYSTORE_NAME="${2:-polyglot}"
            header "[Android] Generating Keystore File: $KEYSTORE_NAME"
            keytool \
                -v \
                -genkey \
                -keystore "${POLYGLOT_ROOT}/${KEYSTORE_NAME}.keystore" \
                -alias "${KEYSTORE_NAME}" \
                -keyalg RSA \
                -validity 10000
        ;;
        *) ;;
    esac
}

