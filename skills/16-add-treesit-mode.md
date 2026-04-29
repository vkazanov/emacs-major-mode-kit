# Skill: Add Tree-Sitter Mode

## Goal

Add an optional tree-sitter-backed major mode in a separate `LANG-ts-mode.el` file
while keeping the ordinary regex/basic `LANG-mode` intact and usable.

## When to use

Use after the regex/basic mode is already useful and the language has an Emacs 29
tree-sitter grammar that can provide better highlighting, indentation, imenu, or defun
navigation.

Do not use this skill when no Emacs tree-sitter grammar language symbol is known or
when the regex/basic mode is sufficient for the requested feature set. If the grammar
symbol is known but the grammar is not installed locally, this skill may still be
applied with no-op missing-grammar behavior.

## Allowed files

- New generated tree-sitter mode file, such as `foo-ts-mode.el`.
- Generated test files, such as `foo-mode-test.el` and optional
  `foo-ts-mode-test.el`.
- Language overview when tree-sitter language, query, indentation, imenu, or defun
  details need to be recorded.
- Sample files used by tree-sitter tests.

Do not remove or rename the generated regex/basic mode file.

## Built-in Emacs APIs

- `define-derived-mode`
- `require`
- `treesit-ready-p`
- `treesit-parser-create`
- `treesit-font-lock-rules`
- `treesit-major-mode-setup`
- `treesit-font-lock-settings`
- `treesit-font-lock-feature-list`
- `treesit-simple-indent-rules`
- `treesit-simple-imenu-settings`
- `treesit-defun-type-regexp`
- `treesit-defun-name-function`
- `setq-local`
- `ert-deftest`
- `cl-letf`

## Requirements

- Create a separate `LANG-ts-mode.el`; do not fold tree-sitter behavior into
  `LANG-mode.el`.
- Make `LANG-ts-mode` derive from `LANG-mode` so existing syntax tables, comments,
  commands, and fallback behavior remain available.
- Require only built-in Emacs libraries, `LANG-mode`, and `treesit`.
- Record tree-sitter details in `reference/language-overview.md`, including at least
  the grammar language symbol used with Emacs tree-sitter APIs.
- Define a mode-specific language constant such as `LANG-ts-mode--language` directly
  in the tree-sitter mode file.
- Keep `LANG-mode` as the file-extension default. `LANG-ts-mode` is opt-in unless a
  later explicit package-polish step documents user-level remapping.
- Check grammar availability inside `LANG-ts-mode` with
  `(treesit-ready-p LANG-ts-mode--language t)` before creating parsers or enabling
  tree-sitter-powered behavior.
- Call `treesit-parser-create` only after the grammar readiness check succeeds.
- Set tree-sitter variables buffer-locally before calling `treesit-major-mode-setup`.
- Use `treesit-font-lock-rules` for tree-sitter font-lock settings when adding
  tree-sitter highlighting.
- Call `treesit-major-mode-setup` only after required parsers have been created.
- No-op cleanly when the grammar is unavailable: enabling `LANG-ts-mode` must not
  signal an error, create a parser, or call `treesit-major-mode-setup`.
- Preserve existing `LANG-mode` tests and behavior.

## Steps

1. Add tree-sitter details to `reference/language-overview.md`.
2. Create `LANG-ts-mode.el` with lexical binding, normal package headers,
   Commentary, Code, `provide`, and a file footer.
3. For common missing-grammar behavior, adapt `templates/snippets/16-treesit-noop.md`.
4. Require `LANG-mode` and `treesit`.
5. Define tree-sitter language data and optional setup constants in a dedicated
   tree-sitter section.
6. If adding tree-sitter highlighting, define a helper or constant based on
   `treesit-font-lock-rules` and choose a conservative
   `treesit-font-lock-feature-list`.
7. If adding tree-sitter indentation, imenu, or defun navigation, define the smallest
   required `treesit-simple-indent-rules`, `treesit-simple-imenu-settings`,
   `treesit-defun-type-regexp`, or `treesit-defun-name-function` values.
8. Define an autoloaded `LANG-ts-mode` derived from `LANG-mode`.
9. Inside `LANG-ts-mode`, check `(treesit-ready-p LANG-ts-mode--language t)`.
10. In the ready branch, call `treesit-parser-create`, set all tree-sitter locals, and
   then call `treesit-major-mode-setup`.
11. In the unavailable branch, do nothing beyond the inherited `LANG-mode` setup.
12. Add tests for available and unavailable grammar behavior, then run validation
    before applying the next skill.

## Tests

- Put tree-sitter-specific tests in `LANG-ts-mode-test.el` when that keeps the base
  mode tests smaller. The root `Makefile` loads every `*-test.el` file in
  `MODE_DIR`.
- Test the unavailable grammar path by stubbing `treesit-ready-p` to return nil.
  Enabling `LANG-ts-mode` should succeed, derive from both `LANG-ts-mode` and
  `LANG-mode`, and not call `treesit-parser-create` or `treesit-major-mode-setup`.
- Test the available grammar path by stubbing `treesit-ready-p`,
  `treesit-parser-create`, and `treesit-major-mode-setup`. Assert parser creation and
  setup are called in order and that expected tree-sitter buffer-local variables are
  set.
- Test that `auto-mode-alist` still maps the language extension to `LANG-mode`, not
  `LANG-ts-mode`.
- Keep tests grammar-independent by default. If adding a smoke test against a real
  grammar, guard it with `ert-skip` when `(treesit-ready-p 'LANG t)` is nil.
- Preserve existing regex/basic mode tests.

## Anti-patterns

- Replacing or deleting `LANG-mode`.
- Registering `LANG-ts-mode` as the default file association in this skill.
- Calling `treesit-parser-create` when `treesit-ready-p` returns nil.
- Calling `treesit-major-mode-setup` before creating required parsers.
- Signaling an error when the grammar is missing.
- Requiring an external Emacs package for tree-sitter support.
- Installing grammars, downloading files, or running external tools during mode load.
- Mutating global tree-sitter, font-lock, indentation, imenu, or defun variables.
- Hiding unrelated highlighting, indentation, navigation, Flymake, run, or format
  rewrites inside the tree-sitter-mode change.

## Validation

```sh
make validate MODE_DIR=path/to/mode MODE=foo
```

Expected result: the regex/basic mode tests keep passing, tree-sitter mode tests pass
without requiring an installed grammar, all generated runtime Lisp files
byte-compile, and no generated `.elc` files remain after cleanup.
