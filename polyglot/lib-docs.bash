#!/usr/bin/env bash

function run_repo_report () {
    header "TODO: Repo Report"
    # generate lines of code, num of files,
    # active languages...
    fail "Not implemented"
}

# Main Access point: --------------------------------------------------

function pg_docs () {
    # Takes N args.
    header "Building Docs"
    local LOOP_ARGS=("$@")
    local _mdbook=0
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

