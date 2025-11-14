#!/usr/bin/env bash

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

function install_android () {
    exit 1
}
