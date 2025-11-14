#!/usr/bin/env bash


function run_towncier () {
    subhead "Generating Changelog"
    towncrier build --yes

}
