# Skill Index

Use this index to select skills, collect language details, and decide applicability
before editing a generated mode. The individual skill document remains authoritative
before applying a skill.

Validation profiles:

- `standard`: `make validate MODE_DIR=path/to/mode MODE=foo`
- `final`: `make validate-polished MODE_DIR=path/to/mode MODE=foo`

Language overview:

- Create `reference/language-overview.md` from `templates/language-overview.md` in
  skill `00`.
- Update the overview when adding language knowledge, source notes, fixture plans, or
  skip reasons.
- Generated Lisp should contain only feature-local runtime constants/helpers required
  by the applied skills.

| id | skill file | feature | depends on / order | applies when | skip when | required details | optional details | outputs | validation |
|---|---|---|---|---|---|---|---|---|---|
| 00 | [00-create-basic-mode.md](00-create-basic-mode.md) | Basic mode package | First skill | A generated mode is being created | Never skip for new modes | `LANG`, `LANGNAME`, `EXT`, `MODE_DIR` | Basic sample | Mode, test, overview, samples | `standard` |
| 01 | [01-add-syntax-table.md](01-add-syntax-table.md) | Syntax table | After `00` | Comments, strings, or escapes can be modeled by syntax table entries | No syntax-table-modeled syntax is requested | Comment delimiters, string delimiters, escape char | Syntax edge cases for skill `15` | Mode, test, overview, samples | `standard` |
| 02 | [02-add-comments.md](02-add-comments.md) | Comment commands | After `01` | The language has comments and syntax state is reliable | No comment syntax | Primary line opener or block-only policy | Alternate comment openers | Mode, test, overview, samples | `standard` |
| 03 | [03-add-font-lock.md](03-add-font-lock.md) | Font lock | After `01` | Keywords, builtins, or definitions should be highlighted | No highlighting details are requested | Keywords, builtins, definition regexps | Extra conservative faces | Mode, test, overview, samples | `standard` |
| 04 | [04-add-indentation.md](04-add-indentation.md) | Indentation | After `01` | A conservative indentation rule is known | No indentation behavior is requested | Indentation style and offset | Dedent tokens, continuation rules, choice markers | Mode, test, overview, samples | `standard` |
| 05 | [05-add-imenu.md](05-add-imenu.md) | Imenu | After definitions are known | Definitions should appear in imenu | No definition/indexing details | Definition regexp and name capture | Group names | Mode, test, overview, samples | `standard` |
| 06 | [06-add-outline.md](06-add-outline.md) | Outline | Optional after syntax state | Source has heading forms | No heading details | Heading regexp | Level function/rules | Mode, test, overview, samples | `standard` |
| 07 | [07-add-beginning-end-of-defun.md](07-add-beginning-end-of-defun.md) | Defun navigation | Optional after definition details | Top-level boundaries are known | No conservative boundary details | Defun start regexp | End rule | Mode, test, overview, samples | `standard` |
| 08 | [08-add-completion-at-point.md](08-add-completion-at-point.md) | Completion | Optional after syntax state | Static or current-buffer completions are useful | No completion sources | Keywords, builtins, or symbol regexp | Current-buffer symbol policy | Mode, test, overview, samples | `standard` |
| 09 | [09-add-eldoc.md](09-add-eldoc.md) | Eldoc | Optional after syntax state | Static docs/signatures exist | No static documentation details | Keyword/builtin docs | Function signatures | Mode, test, overview, samples | `standard` |
| 10 | [10-add-xref.md](10-add-xref.md) | Current-buffer xref | Optional after definition details | Current-buffer lookup is useful | No conservative definition lookup | Identifier and definition regexps | Dotted/special lookup rules | Mode, test, overview, samples | `standard` |
| 11 | [11-add-flymake.md](11-add-flymake.md) | Flymake | Optional after syntax state | Diagnostic command and output format are known | Command or output details are unknown | Tool command, output fixture, severity mapping | Temp-file/stdin policy | Mode, test, overview, fixtures | `standard` |
| 12 | [12-add-compilation-mode.md](12-add-compilation-mode.md) | Compilation mode | Optional after tool details | Compiler/checker output is known | No tool output details | Command shape and error regexps | Custom compilation mode name | Mode, test, overview, fixtures | `standard` |
| 13 | [13-add-run-command.md](13-add-run-command.md) | Run command | Optional after command details | A documented run/play command exists | Run command is unknown | Command, args, compile mode policy | Keybinding | Mode, test, overview | `standard` |
| 14 | [14-add-format-command.md](14-add-format-command.md) | Format command | Optional after formatter details | A documented formatter command exists | Formatter command is unknown | Command, args, stdin/stdout behavior, scope | Region support, keybinding | Mode, test, overview | `standard` |
| 15 | [15-add-syntax-propertize.md](15-add-syntax-propertize.md) | Syntax propertize | Optional after syntax table | Syntax table cannot model a comment/string/escape case | Syntax table is sufficient | Exact context-sensitive syntax case | Multiline region policy | Mode, test, overview, samples | `standard` |
| 16 | [16-add-treesit-mode.md](16-add-treesit-mode.md) | Tree-sitter mode | Optional after base mode | Grammar language symbol and useful tree-sitter behavior are known | No grammar symbol is known | Tree-sitter language symbol | Queries, indentation, imenu, defun rules | Mode, optional `LANG-ts-mode.el`, test, overview | `standard` |
| 17 | [17-polish-package.md](17-polish-package.md) | Final polish | Last skill | Always after selected/applicable features | Never skip | Package metadata and applied feature list | Manual smoke checks | Mode, optional tree-sitter mode, test, samples, overview | `final` |
