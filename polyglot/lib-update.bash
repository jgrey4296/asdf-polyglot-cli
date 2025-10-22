#!/usr/bin/env bash

function run_dotnet_update () {
    if [[ -z $(fdfind "\.sln" "$POLYGLOT_ROOT") ]]; then
        echo "Creating new sln"
        dotnet new sln
    fi

    # must be run sequentially
    fdfind ".(cs|fs)proj" "$POLYGLOT_ROOT" --threads=1 --exec dotnet sln add
}

function export_asdf () {
    tdot "Exporting ASDF plugins"
    asdf plugin list --urls > "$ASDF_PLUGIN_LIST"
}

function export_tex () {
    tdot "Exporting Tex libraries"
    asdf cmd texlive reqs
}

function update_polyglot () {
    run_dotnet_update
}

# Release --------------------------------------------------
function run_release () {
    header "Running $LEVEL Release"

    subhead "Checking for change notifications"
    # one arg: the level of the version to bump
    local LEVEL="${1:-minor}"
    local CURR_VERSION
    local NEW_VERSION
    if [[ -n $(git --no-pager diff) ]]; then
        fail "There are unstaged changes."
    fi
    if [[ -n "$TOWNCRIER_CHANGE_DIR" ]]; then
       [[ -n $(fdfind . "$TOWNCRIER_CHANGE_DIR") ]] || fail "There are no fragment changes. Add descriptions of this release."
    else
        towncrier check || fail "There are no fragment changes. Add descriptions of this release."
    fi

    subhead "Calculating Version Number"
    CURR_VERSION=$(version version)
    version "$LEVEL" "set" "+"
    NEW_VERSION=$(version version)
    echo "Project Version $CURR_VERSION -> $NEW_VERSION"

    subhead "Generating Changelog"
    towncrier build --yes
    run_export

    git add --all
    git commit -m "[Release]: ${NEW_VERSION}"
    git tag "${NEW_VERSION}"
    }

function run_export () {
    header "Exporting Polyglot State"
    export_asdf

    if [[ -e "$POLYGLOT_ROOT/tex.reqs" ]]; then
        export_tex
    fi
    echo "done."
}
