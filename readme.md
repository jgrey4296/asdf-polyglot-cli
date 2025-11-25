<!-- readme.md -*- mode: gfm-mode -*- -->

An asdf plugin to install [polyglot](https://github.com/jgrey4296/asdf-polyglot-cli).

See [polyglot-template](https://github.com/jgrey4296/polyglot-template).

# Polyglot

I switch languages regularly, but can never remember the edge cases and little things
I need to do to set up projects.
Polyglot is my general cookiecutter project template to easily spin up a project.
While this cli tool is for manipulating it.

To Use, add `export POLYGLOT_ROOT="$PWD"` to your .envrc.

Polyglot also aliases as:
- cargo-polyglot
- cargo-pg

## Commands

- `help`
- `list`
- `stub`
- `lang`
- `tool`
- `task`


## Registering language/tool/task commands

`polyglot` looks in `$POLYGLOT_ROOT/.tasks` for directories of the form:
- `lang-{name}`
- `tool-{name}`
- `task-{name}`.

Executable scripts in language and tool directories are run with
`polyglot {lang|tool} {name} [args...]`.
Meanwhile tasks are run with `polyglot task {name} [args...]`, which runs *each* executable in the directory, sorted alphanumerically.
