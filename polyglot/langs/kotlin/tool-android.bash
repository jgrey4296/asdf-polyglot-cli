#!/usr/bin/env bash

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
