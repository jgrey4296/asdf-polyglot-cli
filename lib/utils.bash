#!/usr/bin/env bash

# asdf env vars:
# ASDF_INSTALL_TYPE : version or ref
# ASDF_INSTALL_VERSION : full version number or git ref
# ASDF_INSTALL_PATH : where the tool should be
# ASDF_CONCURRENCY : number of cores
# ASDF_DOWNLOAD_PATH : where bin/download downloads to
# ASDF_PLUGIN_PATH : where the plugin is installed
# ASDF_PLUGIN_SOURCE_URL : url of the plugin
# ASDF_PLUGIN_PREV_REF : previous git-ref of plugin
# ASDF_PLUGIN_POST_REF : updated git-ref of plugin
# ASDF_CMD_FILE : full path of file being sourced

set -euo pipefail

POLYGLOT_VERSION="0.3.0"
GH_REPO="https://github.com/jgrey4294/asdf-polyglot-cli.git"
TOOL_NAME="polyglot"
TOOL_TEST="polyglot --help"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

function sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

function list_all_versions() {
	echo "$POLYGLOT_VERSION"
}
