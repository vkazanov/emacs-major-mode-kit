# Skill: Add Syntax Table

## Goal

Teach the mode Emacs syntax state for comments, strings, and backslash quoting using a syntax
table. This enables `syntax-ppss` to identify comments and strings correctly.

## When to use

Use after `00-create-basic-mode.md`, once the generated mode loads and has a basic test.
Apply this before comment commands, highlighting, indentation, or imenu when those
features depend on syntax state.

## Allowed files

- Generated mode file.
- Generated test file.
- Language overview when comment or string details need to be recorded.
- Sample files used by syntax tests.

## Built-in Emacs APIs

- `make-syntax-table`
- `modify-syntax-entry`
- `syntax-ppss`
- `ert-deftest`

## Requirements

- Define or update `LANG-mode-syntax-table`.
- Pass the syntax table to `define-derived-mode` with `:syntax-table`.
- Record comment and string delimiters in the language overview.
- Include exact syntax recipes for common C-style line comments, block comments,
  double-quoted strings, and backslash quoting when the language uses them.
- When the language has multiple line comment delimiters, include every delimiter
  that can be modeled by a syntax table and leave command-level opener selection to
  `02-add-comments.md`.
- Keep behavior limited to syntax state; do not add comment command variables,
  highlighting, indentation, or imenu here.

## Steps

1. Identify line comment, block comment, string delimiter, and backslash syntax from the
   language overview or samples.
2. For common syntax table recipes, adapt `templates/snippets/01-syntax-table.md`.
3. Update `LANG-mode-syntax-table` with `modify-syntax-entry`.
4. For C-style `//` and `/* */` comments, use this recipe:

   ```elisp
   (modify-syntax-entry ?/ ". 124b" table)
   (modify-syntax-entry ?* ". 23" table)
   (modify-syntax-entry ?\n "> b" table)
   ```

5. For languages that also have a single-character line comment opener such as `#`,
   add that opener to the same comment style:

   ```elisp
   (modify-syntax-entry ?# "< b" table)
   ```

   If a delimiter cannot be modeled reliably with syntax table entries, record the
   detail and defer the case to `15-add-syntax-propertize.md`.

6. For double-quoted strings and backslash quoting, use this recipe:

   ```elisp
   (modify-syntax-entry ?\" "\"" table)
   (modify-syntax-entry ?\\ "\\" table)
   ```

7. Add tests that place point inside representative comments and strings.
8. Run validation before applying the next skill.

## Tests

- Test line comments with `(nth 4 (syntax-ppss))`.
- Test block comments with `(nth 4 (syntax-ppss))` when the language has them.
- Test strings with `(nth 3 (syntax-ppss))`.
- Include a case where comment delimiters inside strings are not comments.

## Anti-patterns

- Parsing the language with broad regexps instead of using syntax table entries.
- Setting `comment-start` or `comment-start-skip` in this skill.
- Adding highlighting, indentation, imenu, command runners, or formatters.
- Classifying syntax globally instead of through the mode syntax table.
- Introducing non-built-in dependencies.

## Validation

```sh
make validate MODE_DIR=path/to/mode MODE=foo
```

Expected result: syntax tests pass and the mode byte-compiles.
