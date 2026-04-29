# Agent Instructions

This repository creates Emacs major modes incrementally using skill documents.

## Operating Workflow

When asked to create or extend a generated major mode:

1. Read `README.md` for repository conventions and validation targets.
2. For real languages with incomplete language details, complete the source-backed
   intake in `docs/real-language-intake.md` before skill `00`.
3. Use `skills/index.md` to expand the requested range/list, collect required
   language details, and decide optional-skill applicability. The individual skill
   file remains authoritative before editing for that feature.
4. Apply skill documents from `skills/` in numeric order. A range such as `00-10`
   expands to every skill from `00` through `10`; a list such as `00-05,08,10`
   expands only to the selected skills in ascending order.
5. Apply only one skill at a time. Do not mix later feature work into an earlier skill.
   Before each feature, open and follow the exact skill file and any snippet it
   references.
6. After each non-final applied skill, run:

   ```sh
   make validate MODE_DIR=path/to/mode MODE=foo
   ```

7. Always apply `skills/17-polish-package.md` last when it was not already selected.
   After skill `17`, run:

   ```sh
   make validate-polished MODE_DIR=path/to/mode MODE=foo
   ```

When extending a generated mode, update `MODE_DIR/reference/language-overview.md`
first when the requested feature needs new language knowledge, then add only the
runtime code required by the applied feature.

## Applicability

Feature selection expands before applicability filtering. Skills `00` through `05` are
core when selected. Skills `06` through `16` are optional/applicability-gated: apply
one only when the requested language, tool, or grammar prerequisites are present.

For broad ranges, do not invent missing optional details just because the range
crosses an optional skill. If details are absent, record the skill as skipped/not
applicable in `reference/language-overview.md` and continue in order.

For sparse lists, treat a listed optional skill as an explicit request. Ask once for
missing required details. If the user says none/unknown, or details remain absent,
skip the skill as not applicable rather than creating placeholder behavior.

A known external tool that is not installed locally is different from an unknown tool.
If the command and output shape are known, implement the feature with command-time
`executable-find` checks and stubbed tests. If command or output details are unknown,
skip the tool-backed skill. If no formatter command is known, skip skill `14`. If no
Emacs tree-sitter grammar language symbol is known, skip skill `16`; if the grammar is
known but not installed locally, skill `16` may still be applied with no-op behavior
when `treesit-ready-p` is nil.

Skill `17` polishes only the features actually applied, preserves documented skip
reasons in the overview, and must not add behavior for skipped optional skills.

## Language Bootstrap Intake

Collect only the details needed for the requested feature range. If the user asks to
"bootstrap", "create a basic mode", or otherwise does not name a range, default to
skills `00` through `05`, followed by final polish skill `17`.

Required for every generated mode:

- `LANG`: Lisp symbol prefix, such as `foo` or `mini-hcl`.
- `LANGNAME`: human-readable language name, such as `Foo` or `Mini HCL`.
- `EXT`: bare file extension, such as `foo`, never `.foo`.
- `MODE_DIR`: generated mode directory, such as `examples/foo-mode`.
- Requested feature range or feature list.
- `MODE_DIR/reference/language-overview.md`.
- Sources and fixture plan when source-backed real-language intake was needed.

Core details for skills `00` through `05`:

- Comments: line comment delimiters, block comment delimiters, or none.
- Strings: string delimiters, escape character, and whether syntax tables are enough.
- Keywords: reserved words that should receive keyword highlighting.
- Builtins: known builtin names that should receive builtin highlighting.
- Definitions: simple forms to index or highlight, including the displayed name.
- Indentation: zero, brace-based, continuation-based, indentation-sensitive,
  choice-depth, or other conservative rule, plus offset.
- Samples: small valid snippets that exercise comments, strings, definitions,
  highlighting, indentation, and imenu.

Optional details for skills `06` through `14`:

- Outline headings and level rules for `outline-regexp`.
- Beginning/end-of-defun boundaries for top-level forms.
- Completion sources beyond keywords and builtins, such as current-buffer symbols.
- Eldoc strings or signatures that can be kept static in feature-local constants.
- Xref definition forms; keep lookup current-buffer only unless explicitly requested
  otherwise.
- Flymake diagnostic tool name and representative output; tools must be optional.
- Compilation command and representative error output.
- Run command, arguments, and whether it should use `compile` or a custom compilation
  mode.
- Formatter command, arguments, stdin/stdout behavior, and region or buffer scope.

Optional details for skills `15` through `16`:

- Syntax-propertize need: the exact comment, string, or escape case that a syntax table
  cannot model.
- Tree-sitter grammar language symbol, query needs, indentation/imenu/defun features,
  and whether `LANG-ts-mode` remains opt-in. Default: keep `LANG-mode` as the file
  association and make `LANG-ts-mode` opt-in.

Final polish details for skill `17`:

- Package polish expectations, including public commands, mode-local keybindings,
  autoloads, customization options, and any documented manual smoke checks.
- Whether a generated `LANG-ts-mode.el` exists and must keep using `LANG-mode`.
- Optional skills skipped with reasons.

When information is missing:

- Ask the user only for details needed by the requested applicable skills.
- Leave optional details blank in the overview when they are not requested or not
  needed yet.
- Do not invent external tool commands, tree-sitter grammars, package names, or
  language semantics.
- Prefer conservative behavior that can be validated with ERT and byte compilation.

## Language Overview

`MODE_DIR/reference/language-overview.md` is the only durable overview of the target
language. It records sources, scope, selected language details, fixtures, applied
skills, and skipped optional skills.

Generated Emacs Lisp files must not contain a central language-overview object. Add
only narrow runtime constants and helpers required by applied features, such as
keyword lists, regexps, syntax tables, command builders, and tree-sitter language
symbols.

## Bootstrap Prompt Template

Use or adapt this template when asking another agent to create a generated mode:

```text
Create MODE_DIR for LANGNAME by applying skills START through END in order, then
apply skill 17 as the final polish step unless END is already 17.
Use LANG=LANG, LANGNAME="LANGNAME", EXT=EXT, MODE_DIR=MODE_DIR, MODE=LANG.

Sources and fixtures:
- sources:
- fixture plan:
- optional skills skipped as not applicable:

Language details:
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

Create reference/language-overview.md, samples, and ERT tests for every applied
feature. Run validation after each non-final applied skill:
make validate MODE_DIR=MODE_DIR MODE=LANG
After skill 17, run:
make validate-polished MODE_DIR=MODE_DIR MODE=LANG
```

## Edit Boundaries

For generated modes, edit only the generated mode file, optional generated
tree-sitter mode file, test files, `reference/language-overview.md`, sample files, and
package-local reference/source notes unless the user explicitly asks for
repository-level changes.

For this repository itself, keep changes scoped to the requested task.

## Shared Skill Rules

1. Use only Emacs 29+ built-ins.
2. Apply one skill at a time.
3. Do not add external package dependencies.
4. Do not rewrite unrelated features.
5. Update `reference/language-overview.md` when adding language knowledge.
6. Add or update ERT tests for every applied feature.
7. Prefer conservative behavior over clever behavior.
8. Do not mutate global Emacs state except autoloaded `auto-mode-alist` registration.
9. Do not add advice.
10. Do not add global keybindings; use mode-local keymaps for commands.
11. Keep regex-based modes and tree-sitter modes separate.
12. Run `make validate` after each non-final applied skill and `make validate-polished`
    after skill `17`.

## Completion Criteria

A feature is complete only when, under both Emacs 29 and Emacs 30 where available:

- the generated runtime files byte-compile,
- relevant ERT tests pass,
- the feature is wired into `define-derived-mode`,
- the overview records applied/skipped skills accurately,
- the code is idiomatic and small.

Use `EMACS=emacs-29` and `EMACS=emacs-30` with the validation targets when both
binaries are installed. If one binary is unavailable in the current environment,
record that gap explicitly in the validation notes.

A generated mode is complete for a requested feature range only when every requested
applicable skill has been applied in order, every skipped optional skill has a reason
in the overview, and validation passes with the generated mode's `MODE_DIR` and
`MODE`.
