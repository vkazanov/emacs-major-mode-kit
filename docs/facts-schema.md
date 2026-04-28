# Language Facts Source

Generated modes use one facts source while skills are being applied.

- Before skill `17`, the facts source is the temporary `LANG-facts.el` file created
  from `templates/lang-facts.el`.
- After skill `17`, the facts source is the inlined `defconst LANG-facts` form inside
  `LANG-mode.el`.
- When extending an already-polished mode, update the inlined constant and do not
  recreate a runtime `LANG-facts.el` file.

The template is the canonical key skeleton. Optional keys may be omitted after final
polish; omitted optional keys are equivalent to `nil`. Required keys for a generated
mode are `:language` and `:extensions`.

## Common Keys

- `:comments`: line and block comment delimiters.
- `:strings`: string delimiters and escape character.
- `:keywords`, `:builtins`: static symbol lists for highlighting, completion, and
  documentation.
- `:definitions`: conservative regexps and capture groups for definitions.
- `:indentation`: style and offset.
- `:outline`, `:defun`, `:completion`, `:eldoc`, `:xref`: editor service facts.
- `:diagnostics`, `:compilation`, `:run`, `:formatter`, `:tools`: optional tool facts.
- `:syntax-propertize`: syntax cases a syntax table cannot model.
- `:treesit`: tree-sitter language symbol and optional query/setup facts.

Do not put research notes, source URLs, or large sample text in the facts source. For
real-language provenance, use package-local documentation such as
`MODE_DIR/reference/sources.md`.
