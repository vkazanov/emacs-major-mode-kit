# Skill: Add Comments

## Goal

Wire the mode into Emacs comment commands by setting buffer-local comment variables.
This should make `comment-region` and `comment-dwim` use the language's comment syntax.

## When to use

Use after `01-add-syntax-table.md` when the language has comment syntax and
`syntax-ppss` already identifies comments correctly.

## Allowed files

- Generated mode file.
- Generated test file.
- Facts source when comment facts need to be updated.
- Sample files used by comment tests.

## Built-in Emacs APIs

- `comment-start`
- `comment-end`
- `comment-start-skip`
- `comment-use-syntax`
- `comment-region`
- `comment-dwim`
- `setq-local`
- `ert-deftest`

## Requirements

- Set comment variables buffer-locally inside `define-derived-mode`.
- Set `comment-start` to the primary line comment opener plus a trailing space when
  appropriate, such as `"// "`. If the language has multiple line comment openers,
  use the documented primary opener from the facts source or the first line opener
  supplied by the user.
- Set `comment-end` to `""` for line comments.
- Set `comment-start-skip` to match the language's supported comment openers.
- Set `comment-use-syntax` when syntax table state should guide comment commands.
- Do not define custom comment commands unless the built-in commands cannot work.

## Steps

1. Read comment delimiters from the facts source or add them there.
2. For common line/block comment variables, adapt
   `templates/snippets/02-comment-variables.md`.
3. In `define-derived-mode`, set `comment-start`, `comment-end`,
   `comment-start-skip`, and optionally `comment-use-syntax` with `setq-local`.
4. For languages with `//` line comments and `/* */` block comments, a practical
   `comment-start-skip` is:

   ```elisp
   "\\(?://+\\|/\\*+\\)\\s *"
   ```

5. For languages with `#`, `//`, and `/* */` comments, keep `comment-start` on the
   primary line opener, such as `"# "` or `"// "`, and match every opener in
   `comment-start-skip`:

   ```elisp
   "\\(?:#+\\|//+\\|/\\*+\\)\\s *"
   ```

6. Add tests for the configured variables and at least one built-in comment command.
7. Run validation before applying the next skill.

## Tests

- Enable the mode and assert the expected values of `comment-start`, `comment-end`,
  and `comment-start-skip`.
- Use `comment-region` on a simple line and assert the resulting text uses the expected
  line comment syntax.
- Keep existing `syntax-ppss` comment tests passing.

## Anti-patterns

- Defining custom comment commands for normal line or block comments.
- Setting global comment variables.
- Adding highlighting, indentation, imenu, command runners, or formatters.
- Mutating unrelated package variables.
- Introducing non-built-in dependencies.

## Validation

```sh
make validate MODE_DIR=path/to/mode MODE=foo
```

Expected result: comment command tests pass and the mode byte-compiles.
