# Agent Instructions

This repository creates Emacs major modes incrementally using skill documents.

## Operating Workflow

When asked to create or extend a generated major mode:

1. Read `README.md` for the repository conventions and validation interface.
2. Identify the required language parameters:
   - `LANG`: Lisp symbol prefix, such as `foo` or `mini-hcl`.
   - `LANGNAME`: human-readable language name, such as `Foo` or `Mini HCL`.
   - `EXT`: bare file extension, such as `foo`, never `.foo`.
   - `MODE_DIR`: generated mode directory, such as `examples/foo-mode`.
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

## Edit Boundaries

For generated modes, edit only the generated mode file, test file, facts file, and
sample files unless the user explicitly asks for repository-level changes.

For this repository itself, keep changes scoped to the requested milestone or TODO.

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
