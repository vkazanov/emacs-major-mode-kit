# Skill: Add Font Lock

## Goal

Add conservative syntax highlighting for language keywords, builtins, and simple
definition names using Emacs font-lock.

## When to use

Use after `01-add-syntax-table.md` and after the language facts contain the keyword,
builtin, or definition data needed for highlighting.

## Allowed files

- Generated mode file.
- Generated test file.
- Generated facts file.
- Sample files used by highlighting tests.

## Built-in Emacs APIs

- `font-lock-defaults`
- `font-lock-ensure`
- `regexp-opt`
- `get-text-property`
- `font-lock-keyword-face`
- `font-lock-builtin-face`
- `font-lock-function-name-face`
- `font-lock-variable-name-face`
- `ert-deftest`

## Requirements

- Store reusable language data in the facts file.
- Use `regexp-opt` for keyword and builtin lists.
- Use built-in font-lock faces only.
- Set `font-lock-defaults` buffer-locally inside `define-derived-mode`.
- Keep regexps conservative and easy to inspect.
- Test face properties after `font-lock-ensure`.
- Handle face values that may be either a symbol or a list.

## Steps

1. Add or update facts such as `:keywords`, `:builtins`, and simple definition regexps.
2. Define `LANG-font-lock-keywords` in the mode file.
3. Use `(regexp-opt ITEMS 'symbols)` for keyword-like identifiers.
4. Add definition-name matchers with explicit capture groups for names.
5. Set `(setq-local font-lock-defaults '(LANG-font-lock-keywords))` in the mode.
6. Add tests that enable the mode, call `font-lock-ensure`, and inspect the `face`
   text property.
7. Run validation before applying the next skill.

## Tests

- Test at least one keyword face.
- Test at least one builtin face when the language has builtins.
- Test function-name or variable-name faces when the language has simple definitions.
- Use a helper that accepts either a face symbol or a list containing the expected face.

## Anti-patterns

- Highlighting with ad hoc global state or overlays.
- Using non-built-in faces when built-in font-lock faces fit.
- Writing broad parser-like regexps.
- Adding indentation, imenu, command runners, or formatters.
- Introducing non-built-in dependencies.

## Validation

```sh
make test MODE_DIR=path/to/mode MODE=foo
make compile MODE_DIR=path/to/mode MODE=foo
make clean MODE_DIR=path/to/mode
```

Expected result: font-lock tests pass and the mode byte-compiles.
