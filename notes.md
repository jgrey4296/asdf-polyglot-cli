<!--  notes.md -*- mode: gfm-mode -*-  -->
<!--
Summary:  

Tags:  

-->

# Polyglot Notes

## Main tool
- initialise the polyglot project (install tools, languages)
- build polyglot docs (each active part, then join together in one html site)
- run release (export polyglot state, update version numbers, tag git)
- list active parts and their languages
- extend with custom sequencing tasks in `.tasks`
- extend with custom lang tasks in `.tasks/lang-{}`
- extend with custom tool tasks in `.tasks/tool-{}`
- extend with custom task hooks in `.tasks/task-{}`


## Template
- pre-sets config files to use .temp as much as possible
- pre-sets env vars

## Language interface:

A `lang-{name}.bash` script providing functions:
- `install_{name}`
- `init_{name}`
- `add_{name}_dep`
- `new_sub_{name}`
- `find_{name}_subs`
- `start_{name}_repl`
- `run_{name}_lint`
- `run_{name}_test`
- `build_{name}`
- `make_{name}_toml_template`
- `report_{name}`
- `add_{name}_config`
- `remove_{name}_config`


## Tool Interface:

A `tool-{name}.bash` script providing functions:
- `install_{name}`
- `run_{name}`
