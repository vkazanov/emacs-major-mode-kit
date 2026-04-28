# Agent Instructions

This repository creates Emacs major modes incrementally using skill documents.

## Operating Workflow

When asked to create or extend a generated major mode:

1. Read `README.md` for the repository conventions and validation interface.
2. Complete the language bootstrap intake below for the requested skill range.
3. Apply skill documents from `skills/` in numeric order, starting with
   `skills/00-create-basic-mode.md`. Before each feature, open and follow the exact
   skill file for that step.
4. Apply only one skill at a time. Do not mix later feature work into an earlier skill.
5. After each skill, run:

   ```sh
   make test MODE_DIR=path/to/mode MODE=foo
   make compile MODE_DIR=path/to/mode MODE=foo
   ```

6. Run `make clean` after byte compilation so generated `.elc` files are not left
   behind.

## Language Bootstrap Intake

Collect only the facts needed for the requested skill range. If the user asks to
"bootstrap", "create a basic mode", or otherwise does not name a range, default to
skills `00` through `05`.

Required for every generated mode:

- `LANG`: Lisp symbol prefix, such as `foo` or `mini-hcl`.
- `LANGNAME`: human-readable language name, such as `Foo` or `Mini HCL`.
- `EXT`: bare file extension, such as `foo`, never `.foo`.
- `MODE_DIR`: generated mode directory, such as `examples/foo-mode`.
- Requested skill range or feature list, such as `00-05`, `00-10`, or
  `00-17`.

Core facts for skills `00` through `05`:

- Comments: line comment delimiters, block comment delimiters, or none.
- Strings: string delimiters, escape character, and whether syntax tables are enough.
- Keywords: reserved words that should receive keyword highlighting.
- Builtins: known builtin names that should receive builtin highlighting.
- Definitions: simple forms to index or highlight, including the displayed name.
- Indentation: zero, brace-based, indentation-sensitive, continuation-based, or other
  conservative rule, plus offset.
- Samples: small valid snippets that exercise comments, strings, definitions,
  highlighting, indentation, and imenu.

Optional facts for skills `06` through `14`:

- Outline headings and level rules for `outline-regexp`.
- Beginning/end-of-defun boundaries for top-level forms.
- Completion sources beyond keywords and builtins, such as current-buffer symbols.
- Eldoc strings or signatures that can be kept static in the facts file.
- Xref definition forms; keep lookup current-buffer only unless explicitly requested
  otherwise.
- Flymake diagnostic tool name and representative output; tools must be optional.
- Compilation command and representative error output.
- Run command, arguments, and whether it should use `compile` or a custom compilation
  mode.
- Formatter command, arguments, stdin/stdout behavior, and region or buffer scope.

Optional facts for skills `15` through `17`:

- Syntax-propertize need: the exact comment, string, or escape case that a syntax table
  cannot model.
- Tree-sitter grammar language symbol, query needs, indentation/imenu/defun features,
  and whether `LANG-ts-mode` remains opt-in. Default: keep `LANG-mode` as the file
  association and make `LANG-ts-mode` opt-in.
- Package polish expectations, including public commands, mode-local keybindings,
  autoloads, customization options, and any documented manual smoke checks.

When information is missing:

- Ask the user only for facts needed by the requested skill range.
- Leave optional facts as `nil` when they are not requested or not needed yet.
- Do not invent external tool commands, tree-sitter grammars, package names, or
  language semantics.
- Prefer conservative behavior that can be validated with ERT and byte compilation.

## Bootstrap Prompt Template

Use or adapt this template when asking another agent to create a generated mode:

```text
Create MODE_DIR for LANGNAME by applying skills START through END in order.
Use LANG=LANG, LANGNAME="LANGNAME", EXT=EXT, MODE_DIR=MODE_DIR, MODE=LANG.

Language facts:
- comments:
- strings:
- keywords:
- builtins:
- definitions:
- indentation:
- outline:
- defun navigation:
- completion:
- Eldoc:
- xref:
- diagnostics:
- compilation:
- run command:
- formatter:
- syntax propertize:
- tree-sitter:

Add samples and ERT tests for every applied feature. Run validation after each skill:
make test MODE_DIR=MODE_DIR MODE=LANG
make compile MODE_DIR=MODE_DIR MODE=LANG
Run make clean after byte compilation so no .elc files remain.
```

## Edit Boundaries

For generated modes, edit only the generated mode file, test file, facts file, and
sample files unless the user explicitly asks for repository-level changes.

For this repository itself, keep changes scoped to the requested task.

## Rules

1. Use only Emacs 29+ built-ins.
2. Apply one skill at a time.
3. Do not add external package dependencies.
4. Do not rewrite unrelated features.
5. Update the language facts file when adding language knowledge.
6. Add or update ERT tests for every feature.
7. Prefer conservative behavior over clever behavior.
8. Do not mutate global Emacs state except autoloaded `auto-mode-alist` registration.
9. Do not add advice.
10. Do not add global keybindings; use mode-local keymaps for commands.
11. Keep regex-based modes and tree-sitter modes separate.
12. Run tests after each feature.

## Completion Criteria

A feature is complete only when both under emacs 29 and emacs 30:

- the mode byte-compiles,
- relevant ERT tests pass,
- the feature is wired into `define-derived-mode`,
- the code is idiomatic and small.

A generated mode is complete for a requested skill range only when every skill in that
range has been applied in order, the facts file reflects language knowledge added by
those skills, and validation passes with the generated mode's `MODE_DIR` and `MODE`.
