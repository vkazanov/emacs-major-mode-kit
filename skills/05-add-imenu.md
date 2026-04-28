# Skill: Add Imenu

## Goal

Expose simple definitions to Emacs imenu so users can jump to top-level functions,
types, or similar named forms.

## When to use

Use after the mode has a working basic implementation and the facts file contains a
simple one-line definition regexp, such as `func NAME`.

## Allowed files

- Generated mode file.
- Generated test file.
- Generated facts file.
- Sample files used by imenu tests.

## Built-in Emacs APIs

- `imenu-generic-expression`
- `imenu-create-index-function`
- `imenu--make-index-alist`
- `setq-local`
- `ert-deftest`

## Requirements

- Prefer `imenu-generic-expression` for simple one-line definitions.
- Define a language-specific expression such as `LANG-imenu-generic-expression`.
- Set `imenu-generic-expression` buffer-locally inside `define-derived-mode`.
- Use regexps with a capture group for the displayed name.
- Use `imenu-create-index-function` only when generic expressions cannot represent the
  language's simple definitions.
- Do not build a persistent symbol index.

## Steps

1. Add or confirm definition regexps in the facts file.
2. Define `LANG-imenu-generic-expression` in the mode file.
3. Set `imenu-generic-expression` in the mode.
4. Add or update samples with multiple definitions.
5. Add tests using `imenu--make-index-alist`.
6. Run validation before applying the next skill.

## Tests

- Enable the mode in a temp buffer with at least two definitions.
- Call `imenu--make-index-alist`.
- Assert expected names are present with `assoc`.
- Keep earlier feature tests passing.

## Anti-patterns

- Writing a custom index function for simple one-line definitions.
- Scanning project files or creating persistent caches.
- Adding completion, diagnostics, command runners, or formatters.
- Mutating global imenu variables.
- Introducing non-built-in dependencies.

## Validation

```sh
make test MODE_DIR=path/to/mode MODE=foo
make compile MODE_DIR=path/to/mode MODE=foo
```

Expected result: imenu tests pass and the mode byte-compiles.
