# Minimal Emacs Major Mode Kit

This repository provides a small framework for creating Emacs 29+ major modes
incrementally. A generated mode starts from simple templates, then grows by applying one
skill document at a time and validating each change with built-in Emacs tools.

The framework intentionally avoids external Emacs package dependencies. Generated modes
should look like ordinary Emacs Lisp packages built around `define-derived-mode`,
mode-local state, ERT tests, and byte compilation.

## State

This skill set was tested to generated a few prog-modes for simple language using the
00-05 skills. I am still negotiating the remaining 12 skills with my agents. See
`docs/agent-validation` for how I go about testing things.

## Repository Layout

```text
minimal-mode-kit/
  AGENTS.md
  README.md
  Makefile

  templates/
    lang-mode.el
    lang-mode-test.el
    lang-facts.el

  skills/
    00-create-basic-mode.md
    01-add-syntax-table.md
    02-add-comments.md
    03-add-font-lock.md
    04-add-indentation.md
    05-add-imenu.md
    06-add-outline.md
    07-add-beginning-end-of-defun.md
    08-add-completion-at-point.md
    09-add-eldoc.md
    10-add-xref.md
    11-add-flymake.md
    12-add-compilation-mode.md
    13-add-run-command.md
    14-add-format-command.md
    15-add-syntax-propertize.md
    16-add-treesit-mode.md
    17-polish-package.md

  examples/
    toy-mode/
      toy-mode.el
      toy-mode-test.el
      toy-facts.el
      samples/
        basic.toy
        font-lock.toy
        indentation.toy
        imenu.toy
```

## Practical quickstart

1. Copy or instantiate the three templates for your language:
   `templates/lang-mode.el`, `templates/lang-mode-test.el`, and
   `templates/lang-facts.el`.
2. Replace placeholders consistently:
   `LANG` is the Lisp prefix, `LANGNAME` is the human-readable language name, and
   `EXT` is the bare file extension.
3. Update the language facts file with reusable language data such as extensions,
   comments, keywords, definitions, indentation style, and optional tools.
4. Apply one skill document at a time, starting with `skills/00-create-basic-mode.md`
   and then adding only the next feature you need.
5. Add or update ERT tests for the behavior introduced by that skill.
6. Run validation before moving to the next skill.

The toy example applies skills `00` through `05`: basic mode, syntax table, comments,
font-lock, indentation, and imenu.

## Conventions

- `EXT` is always the bare extension, such as `toy`, never `.toy`.
- Prose may say `.toy` only when referring to real filenames or glob patterns, such as
  `basic.toy` or `*.toy`.
- Skill files run from `00-create-basic-mode.md` through `17-polish-package.md`.
- Skill `15` is `15-add-syntax-propertize.md`, skill `16` is
  `16-add-treesit-mode.md`, and skill `17` is `17-polish-package.md`.
- Apply one skill at a time and run validation after each feature.
- Use only Emacs 29+ built-ins; do not add external Emacs package dependencies.
- Commands should use mode-local keymaps, not global keybindings.

## Validation

By default, the root `Makefile` validates the toy example:

```sh
make test
make compile
```

Generated modes can use the same targets by passing `MODE_DIR` and `MODE`:

```sh
make test MODE_DIR=path/to/mode MODE=foo
make compile MODE_DIR=path/to/mode MODE=foo
```

`MODE_DIR` is the directory containing the generated mode, and `MODE` is the language
prefix used in filenames such as `foo-mode.el` and `foo-mode-test.el`.
