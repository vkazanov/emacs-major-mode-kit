# Minimal Emacs Major Mode Kit

This repository provides a small framework for creating Emacs 29+ major modes
incrementally. A generated mode starts from simple templates, then grows by applying one
skill document at a time and validating each change with built-in Emacs tools.

The framework intentionally avoids external Emacs package dependencies. Generated modes
should look like ordinary Emacs Lisp packages built around `define-derived-mode`,
mode-local state, ERT tests, and byte compilation.

## Status

The skill documents currently run from `00-create-basic-mode.md` through
`17-polish-package.md`. The committed toy example applies skills `00` through `05`
and final polish skill `17`; `docs/agent-validation.md` describes cross-agent
validation scenarios for additional language subsets.

Agents should treat `AGENTS.md` as the canonical workflow and language-bootstrap
intake document.

## Repository Layout

```text
emacs-major-mode-kit/
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
      samples/
        basic.toy
        font-lock.toy
        indentation.toy
        imenu.toy
```

## Create a Mode

1. Copy or instantiate the three templates for your language:
   `templates/lang-mode.el`, `templates/lang-mode-test.el`, and
   `templates/lang-facts.el`.
2. Replace placeholders consistently:
   `LANG` is the Lisp prefix, `LANGNAME` is the human-readable language name, and
   `EXT` is the bare file extension.
3. Update the language facts file with reusable language data such as extensions,
   comments, keywords, definitions, indentation style, and optional tools. This file is
   a temporary scaffold for skills `00` through `16`.
4. Apply one skill document at a time. If no range is requested, use the default
   bootstrap range: skills `00` through `05`, followed by final polish skill `17`.
5. Add or update ERT tests for the behavior introduced by that skill.
6. Run validation before moving to the next skill.
7. Always finish with `skills/17-polish-package.md`, which inlines `LANG-facts.el`
   into the main mode file and removes the separate runtime facts file.

Feature ranges are cumulative: `00-10` means apply every skill from `00` through
`10` in numeric order. Feature lists are sparse and explicit: `00-05,08,10` means
apply only those selected skills, still in ascending numeric order. Skill `17` is
always the final wrap-up unless it is already part of the requested range.

The toy example applies skills `00` through `05`: basic mode, syntax table, comments,
font-lock, indentation, and imenu. It also applies skill `17`, so its language facts
are inlined into `toy-mode.el`.

## Conventions

- `EXT` is always the bare extension, such as `toy`, never `.toy`.
- Prose may say `.toy` only when referring to real filenames or glob patterns, such as
  `basic.toy` or `*.toy`.
- Skill files run from `00-create-basic-mode.md` through `17-polish-package.md`.
- Skill `15` is `15-add-syntax-propertize.md`, skill `16` is
  `16-add-treesit-mode.md`, and skill `17` is `17-polish-package.md`.
- Apply one skill at a time and run validation after each feature.
- Always apply skill `17` as the final step, even when the requested feature range
  stops earlier.
- Use only Emacs 29+ built-ins; do not add external Emacs package dependencies.
- Commands should use mode-local keymaps, not global keybindings.

## Validation

By default, the root `Makefile` validates the toy example:

```sh
make test
make compile
make polish-check
make clean
```

Generated modes can use the same targets by passing `MODE_DIR` and `MODE`:

```sh
make test MODE_DIR=path/to/mode MODE=foo
make compile MODE_DIR=path/to/mode MODE=foo
make polish-check MODE_DIR=path/to/mode MODE=foo
make clean MODE_DIR=path/to/mode
```

`MODE_DIR` is the directory containing the generated mode, and `MODE` is the language
prefix used in filenames such as `foo-mode.el` and `foo-mode-test.el`.

`make compile` byte-compiles runtime files matching `$(MODE_DIR)/$(MODE)-*.el`,
excluding `$(MODE)-mode-test.el`. This includes optional files such as
`foo-ts-mode.el` and temporary files such as `foo-facts.el` before final polish.
`make polish-check` runs package metadata checks against the same runtime files, and
`make clean` removes byte-compiled files only under `MODE_DIR`.

When both Emacs 29 and Emacs 30 are available, run the same validation with each
binary:

```sh
make test EMACS=emacs-29 MODE_DIR=path/to/mode MODE=foo
make compile EMACS=emacs-29 MODE_DIR=path/to/mode MODE=foo
make test EMACS=emacs-30 MODE_DIR=path/to/mode MODE=foo
make compile EMACS=emacs-30 MODE_DIR=path/to/mode MODE=foo
```

If one version is not installed locally, record that gap in the validation notes
instead of inventing a result.
