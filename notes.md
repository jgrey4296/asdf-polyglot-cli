<!--  notes.md -*- mode: gfm-mode -*-  -->
<!--
Summary:  

Tags:  

-->

# Polyglot Notes

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
