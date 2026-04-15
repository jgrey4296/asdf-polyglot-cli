#!/usr/bin/env bash
# lib.bash -*- mode: sh -*-
# shellcheck disable=SC2034,SC1091
#set -o errexit
set -o nounset
set -o pipefail

NOTHING=50
PRINTED_HELP=2

POLYGLOT_DIR=".polyglot"
HEADER_PREFIX="|| *"
HEADER_LINE="------------------------------"
SUBHEAD_LINE="----------"
TDOT_LINE="..."

source "$POLY_SRC/lib/lib-util.bash"
source "$POLY_SRC/lib/lib-logging.bash"
source "$POLY_SRC/lib/lib-helpers.bash"
source "$POLY_SRC/lib/lib-runners.bash"
