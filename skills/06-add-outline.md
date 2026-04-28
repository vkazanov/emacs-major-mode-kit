# Skill: Add Outline

## Goal

Expose language headings to Emacs outline navigation by setting buffer-local outline
variables. This lets users and tests use built-in outline movement without enabling
`outline-minor-mode` automatically.

## When to use

Use after the mode has a working basic implementation and the language has recognizable
heading-like forms, such as section headers, top-level definitions, or Markdown-style
headings.

## Allowed files

- Generated mode file.
- Generated test file.
- Generated facts file when heading facts need to be recorded.
- Sample files used by outline tests.

## Built-in Emacs APIs

- `outline-regexp`
- `outline-level`
- `outline-next-heading`
- `outline-previous-heading`
- `outline-up-heading`
- `setq-local`
- `ert-deftest`

## Requirements

- Store reusable heading facts in the facts file when useful.
- Set `outline-regexp` buffer-locally inside `define-derived-mode`.
- Define and set `outline-level` only when the language has nested heading levels or
  when the heading regexp needs custom level calculation.
- Keep the regexp anchored to real headings and avoid matching ordinary body text.
- Do not enable `outline-minor-mode` automatically from the major mode.
- Do not add custom outline commands unless built-in outline movement cannot work.

## Steps

1. Identify the language's heading forms from the facts file or samples.
2. Add or update facts for heading regexps and heading level rules.
3. Define a language-specific regexp such as `LANG-outline-regexp`.
4. Define `LANG-outline-level` only when a custom level function is needed.
5. In `define-derived-mode`, set `outline-regexp` and optional `outline-level` with
   `setq-local`.
6. Add tests that enable the mode, assert the local outline variables, and move between
   headings with built-in outline functions.
7. Run validation before applying the next skill.

## Tests

- Enable the mode in a temp buffer with at least two sample headings.
- Assert `outline-regexp` is the expected buffer-local value.
- Assert `outline-level` is buffer-local when the skill adds a custom level function.
- Use `outline-next-heading` and `outline-previous-heading` to verify movement lands on
  sample headings.
- Include nested headings when the language supports levels.

## Anti-patterns

- Enabling `outline-minor-mode` automatically.
- Setting global outline variables.
- Writing broad regexps that match comments, strings, or ordinary body text as headings.
- Adding defun navigation, completion, diagnostics, command runners, or formatters.
- Introducing non-built-in dependencies or external packages.

## Validation

```sh
make test MODE_DIR=path/to/mode MODE=foo
make compile MODE_DIR=path/to/mode MODE=foo
```

Expected result: outline tests pass and the mode byte-compiles.
