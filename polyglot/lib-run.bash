#!/usr/bin/env bash
# Scripts for running aspects of the polyglot project

function run_godot () {
    header "TODO: Run Godot"
}

function run_prolog () {
    header "TODO: Run prolog"
}

function run_ansprolog () {
    header "TODO: run ansprolog"
}

function run_rocq () {
    header "TODO: run rocq"
}

function run_dispy () {
    # 1 or 2 args: target, and out
    header "TODO: Python Disassembly"
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

# linting --------------------------------------------------


# android keystore --------------------------------------------
function run_keystore () {
    # up to 2 args. 'new' and the name of the keystore file
    case $1 in
        new)
            KEYSTORE_NAME="${2:-polyglot}"
            header "Generating Android Keystore File: $KEYSTORE_NAME"
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

