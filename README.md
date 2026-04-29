# Minimal Emacs Major Mode Kit

This repository provides a small framework for creating Emacs 29+ major modes
incrementally. A generated mode starts from simple templates, then grows by applying
one skill document at a time and validating each change with built-in Emacs tools.

The framework intentionally avoids external Emacs package dependencies. Generated
modes should look like ordinary Emacs Lisp packages built around `define-derived-mode`,
mode-local state, ERT tests, byte compilation, and a package-local language overview.

## Status

The skill documents currently run from `00-create-basic-mode.md` through
`17-polish-package.md`. The committed toy example applies skills `00` through `05`
and final polish skill `17`; `docs/agent-validation.md` describes cross-agent
validation scenarios for additional language subsets.

Agents should treat `AGENTS.md` as the canonical workflow and language-bootstrap
intake document. `skills/index.md` is a planning aid for language-detail collection
and applicability decisions; each numbered skill remains authoritative for
implementation.

## Repository Layout

```text
emacs-major-mode-kit/
  AGENTS.md
  README.md
  Makefile

  docs/
    agent-validation.md
    language-overview.md
    real-language-intake.md

  templates/
    lang-mode.el
    lang-mode-test.el
    language-overview.md
    snippets/
      README.md
      NN-feature.md

  skills/
    index.md
    00-create-basic-mode.md
    ...
    17-polish-package.md

  examples/
    toy-mode/
      toy-mode.el
      toy-mode-test.el
      reference/
        language-overview.md
      samples/
```

## Create a Mode

1. For real languages with missing details, complete the source-backed intake in
   `docs/real-language-intake.md`.
2. Use `skills/index.md` to expand the requested range/list and decide which optional
   skills apply.
3. Copy or instantiate `templates/lang-mode.el`, `templates/lang-mode-test.el`, and
   `templates/language-overview.md`.
4. Replace placeholders consistently: `LANG` is the Lisp prefix, `LANGNAME` is the
   human-readable language name, and `EXT` is the bare file extension.
5. Record language knowledge, sources, fixture plans, applied skills, and skipped
   optional skills in `MODE_DIR/reference/language-overview.md`.
6. Apply one skill document at a time. If no range is requested, use the default
   bootstrap range: skills `00` through `05`, followed by final polish skill `17`.
7. Add or update ERT tests for the behavior introduced by that skill and run
   validation before moving to the next skill.
8. Always finish with `skills/17-polish-package.md`, which verifies package quality
   and consistency with the language overview.

Feature ranges are candidate selections: `00-10` expands to every skill from `00`
through `10` in numeric order. Feature lists are sparse and explicit: `00-05,08,10`
selects only those skills, still in ascending numeric order. Optional skills `06`
through `16` are applied only when their language/tool/grammar prerequisites are
known; otherwise record them as skipped/not applicable in the overview. Skill `17` is
always the final wrap-up unless it is already part of the requested range.

When extending a generated mode, update the overview first when new language knowledge
is needed, then apply only the missing applicable skills.

## Conventions

- `EXT` is always the bare extension, such as `toy`, never `.toy`.
- Prose may say `.toy` only when referring to real filenames or glob patterns, such as
  `basic.toy` or `*.toy`.
- Skill files run from `00-create-basic-mode.md` through `17-polish-package.md`.
- Skill `15` is `15-add-syntax-propertize.md`, skill `16` is
  `16-add-treesit-mode.md`, and skill `17` is `17-polish-package.md`.
- Apply one skill at a time and run validation after each applied feature.
- Use only Emacs 29+ built-ins; do not add external Emacs package dependencies.
- Commands should use mode-local keymaps, not global keybindings.
- Snippets in `templates/snippets/` are copy/adapt references, not runtime libraries.
- Generated Lisp files should contain only feature-local runtime constants and
  helpers required by applied behavior; the language overview is the durable
  high-level description.

## Validation

By default, the root `Makefile` validates the toy example:

```sh
make validate
make validate-polished
```

Generated modes use the same targets by passing `MODE_DIR` and `MODE`:

```sh
make validate MODE_DIR=path/to/mode MODE=foo
make validate-polished MODE_DIR=path/to/mode MODE=foo
```

`make validate` checks that `reference/language-overview.md` exists, runs ERT tests,
byte-compiles generated runtime files, and cleans byte-code under `MODE_DIR`.
`make validate-polished` also runs package metadata checks.

The lower-level targets remain available:

```sh
make overview-check MODE_DIR=path/to/mode MODE=foo
make test MODE_DIR=path/to/mode MODE=foo
make compile MODE_DIR=path/to/mode MODE=foo
make polish-check MODE_DIR=path/to/mode MODE=foo
make clean MODE_DIR=path/to/mode
```

`MODE_DIR` is the directory containing the generated mode, and `MODE` is the language
prefix used in filenames such as `foo-mode.el` and `foo-mode-test.el`.

`make test` loads every test file matching `$(MODE_DIR)/*-test.el`, so optional
feature tests can live in files such as `foo-ts-mode-test.el`.

`make compile` byte-compiles runtime files matching `$(MODE_DIR)/$(MODE)-*.el`,
excluding all `$(MODE_DIR)/*-test.el` files. This includes optional files such as
`foo-ts-mode.el`.

`make polish-check` runs package metadata checks against runtime files with
`checkdoc-current-buffer` and `lm-verify`.

When both Emacs 29 and Emacs 30 are available, run validation with each binary:

```sh
make validate EMACS=emacs-29 MODE_DIR=path/to/mode MODE=foo
make validate-polished EMACS=emacs-29 MODE_DIR=path/to/mode MODE=foo
make validate EMACS=emacs-30 MODE_DIR=path/to/mode MODE=foo
make validate-polished EMACS=emacs-30 MODE_DIR=path/to/mode MODE=foo
```

If one version is not installed locally, record that gap in the validation notes
instead of inventing a result.
