#!/usr/bin/env bash

function run_dotnet_update () {
    if [[ -n "$DOTNET_ROOT" ]] && [[ -d "$DOTNET_ROOT" ]]; then
        dotnet new sln
        dotnet sln add ./src/cs_*
    fi
}

function export_asdf () {
    tdot "Exporting ASDF plugins"
    asdf plugin list --urls > "$ASDF_PLUGIN_LIST"
}

function export_tex () {
    tdot "Exporting Tex libraries"
    asdf cmd texlive reqs
}

# Release --------------------------------------------------
function run_release () {
    # one arg: the level of the version to bump
    local LEVEL="${1:-minor}"
    local CURR_VERSION
    local NEW_VERSION
    if [[ -n $(git --no-pager diff) ]]; then
        fail "There are unstaged changes."
    fi
    towncrier check || fail "There are no fragment changes. Add descriptions of this release."

    header "Running $LEVEL Release"
    CURR_VERSION=$(version version)
    version "$LEVEL" "set" "+"
    NEW_VERSION=$(version version)
    echo "Project Version $CURR_VERSION -> $NEW_VERSION"

    echo "Generating Changelog"
    towncrier build --yes
    pg_export

    git add --all
    git commit -m "[Release]: ${NEW_VERSION}"
    git tag "${NEW_VERSION}"
    }
