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
- Generated facts file when comment or string facts need to be recorded.
- Sample files used by syntax tests.

## Built-in Emacs APIs

- `make-syntax-table`
- `modify-syntax-entry`
- `syntax-ppss`
- `ert-deftest`

## Requirements

- Define or update `LANG-mode-syntax-table`.
- Pass the syntax table to `define-derived-mode` with `:syntax-table`.
- Record comment and string delimiters in the facts file when they are language facts.
- Include exact syntax recipes for common C-style line comments, block comments,
  double-quoted strings, and backslash quoting when the language uses them.
- Keep behavior limited to syntax state; do not add comment command variables,
  highlighting, indentation, or imenu here.

## Steps

1. Identify line comment, block comment, string delimiter, and backslash syntax from the
   language facts or samples.
2. Update `LANG-mode-syntax-table` with `modify-syntax-entry`.
3. For C-style `//` and `/* */` comments, use this recipe:

   ```elisp
   (modify-syntax-entry ?/ ". 124b" table)
   (modify-syntax-entry ?* ". 23" table)
   (modify-syntax-entry ?\n "> b" table)
   ```

4. For double-quoted strings and backslash quoting, use this recipe:

   ```elisp
   (modify-syntax-entry ?\" "\"" table)
   (modify-syntax-entry ?\\ "\\" table)
   ```

5. Add tests that place point inside representative comments and strings.
6. Run validation before applying the next skill.

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
make test MODE_DIR=path/to/mode MODE=foo
make compile MODE_DIR=path/to/mode MODE=foo
```

Expected result: syntax tests pass and the mode byte-compiles.
