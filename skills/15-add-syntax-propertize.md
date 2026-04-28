# Skill: Add Syntax Propertize

## Goal

Add optional `syntax-propertize-function` support for language syntax state that
cannot be modeled accurately by the mode syntax table alone.

## When to use

Use after `01-add-syntax-table.md` when comments, strings, or escapes have
context-sensitive delimiters that a syntax table alone cannot represent. Expect syntax
state changes here to affect features that depend on `syntax-ppss`, such as comments,
font-lock, indentation, imenu, completion, Eldoc, or xref.

Do not use this skill when fixed character syntax in `LANG-mode-syntax-table` is
sufficient.

## Allowed files

- Generated mode file.
- Generated test file.
- Generated facts file when comment, string, or escape facts need to be recorded.
- Sample files used by syntax propertize tests.

## Built-in Emacs APIs

- `syntax-propertize-function`
- `syntax-propertize-rules`
- `syntax-propertize`
- `syntax-ppss`
- `string-to-syntax`
- `syntax-propertize-extend-region-functions`
- `syntax-propertize-multiline`
- `add-hook`
- `setq-local`
- `ert-deftest`

## Requirements

- Keep the ordinary syntax table as the source of fixed syntax facts.
- Use syntax propertize only for comments, strings, or escapes that the syntax table
  alone cannot model accurately.
- Record new language facts about context-sensitive comments, strings, or escapes in
  the facts file.
- Place rules, helpers, and related constants in the generated mode file's
  `;;;; Syntax propertize` section.
- Define a mode-specific function such as `LANG-mode--syntax-propertize`.
- Prefer `syntax-propertize-rules` when regular-expression rules can express the
  needed delimiter adjustments clearly.
- Use `string-to-syntax` when setting `syntax-table` text properties manually.
- Set `syntax-propertize-function` buffer-locally inside `define-derived-mode`.
- Ensure the mode-specific `syntax-propertize-function` applies all `syntax-table`
  text properties needed for the requested region.
- For multiline constructs, add a small, tested region-extension function with
  `syntax-propertize-extend-region-functions` using `add-hook` with LOCAL non-nil, or
  use `syntax-propertize-multiline` when marking `syntax-multiline` properties is
  enough.
- Keep the implementation limited to syntax-table text properties.

## Steps

1. Identify the exact syntax case that the syntax table alone cannot handle.
2. Add or update facts for the affected comments, strings, or escapes.
3. Add a `;;;; Syntax propertize` section if the mode file does not already have one.
4. Implement `LANG-mode--syntax-propertize` with `syntax-propertize-rules` for simple
   regexp-based delimiter marking, or a small custom function when rules are not
   expressive enough.
5. If writing a custom function, limit text property changes to the region passed as
   `START` and `END`, and apply `syntax-table` values made with `string-to-syntax`.
6. If the construct can span propertization boundaries, add a conservative local
   `syntax-propertize-extend-region-functions` hook with `add-hook`, or mark the
   relevant range with `syntax-multiline` and add `syntax-propertize-multiline`
   locally.
7. In `define-derived-mode`, set `syntax-propertize-function` with `setq-local`.
8. Add tests for the new syntax state and for ordinary syntax table behavior that
   should remain unchanged.
9. Run validation before applying the next skill.

## Tests

- Enable the mode, insert representative source text, call `syntax-propertize` up to
  the position under test, and assert syntax state with `syntax-ppss`.
- Test the specific context-sensitive comment, string, or escape case that required
  syntax propertize.
- Include a negative case where similar text must not become a comment or string.
- Include a case proving existing syntax table behavior still works, such as ordinary
  line comments, block comments, strings, or backslash escapes.
- For multiline constructs, edit or propertize from positions inside the construct and
  assert `syntax-ppss` remains correct after the region-extension behavior runs.

## Anti-patterns

- Using syntax propertize as a broad parser-like recognizer.
- Replacing a sufficient syntax table with syntax propertize rules.
- Adding highlighting, indentation, navigation, tree-sitter, xref, Flymake, run, or
  format behavior in this skill.
- Applying arbitrary text properties unrelated to syntax state.
- Mutating global syntax or propertization variables.
- Depending on external packages or external tools.
- Letting syntax propertize scan the whole buffer unnecessarily for every change.

## Validation

```sh
make test MODE_DIR=path/to/mode MODE=foo
make compile MODE_DIR=path/to/mode MODE=foo
make clean MODE_DIR=path/to/mode
```

Expected result: syntax propertize tests pass, existing syntax table tests keep
passing, and the mode byte-compiles.
