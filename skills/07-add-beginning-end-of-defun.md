# Skill: Add Beginning/End Of Defun

## Goal

Wire the mode into Emacs defun navigation so `beginning-of-defun` and `end-of-defun`
move across the language's top-level definitions.

## When to use

Use after the mode has reliable syntax state and the facts source contains a conservative
definition regexp, such as a one-line function, type, section, or block declaration.

## Allowed files

- Generated mode file.
- Generated test file.
- Facts source when definition facts need to be updated.
- Sample files used by defun navigation tests.

## Built-in Emacs APIs

- `beginning-of-defun-function`
- `end-of-defun-function`
- `beginning-of-defun`
- `end-of-defun`
- `syntax-ppss`
- `re-search-backward`
- `re-search-forward`
- `forward-line`
- `beginning-of-line`
- `setq-local`
- `ert-deftest`

## Requirements

- Store reusable definition regexps in the facts source.
- Define a language-specific beginning function such as
  `LANG-beginning-of-defun`.
- Set `beginning-of-defun-function` buffer-locally inside `define-derived-mode`.
- The beginning function accepts the same optional argument as `beginning-of-defun`.
- Define and set `end-of-defun-function` only when the generic Emacs behavior is not
  good enough for the language.
- The end function takes no arguments and is called after point has been moved to the
  beginning of a defun.
- Skip candidate definition matches inside strings or comments using `syntax-ppss`.
- Prefer the small `re-search-backward` / `re-search-forward` helper recipe from the
  snippet over open-coded point, `bobp`, or `bolp` loops.
- On successful beginning searches, move to the beginning of the matched definition
  line and return non-nil. On failure, leave point where the failed search stops and
  return nil.

## Steps

1. Add or confirm the definition regexp and name capture in the facts source.
2. For reusable syntax-aware definition scanning, adapt
   `templates/snippets/07-definition-scanning.md`.
3. Implement a helper that searches for definition starts in a direction and rejects
   matches where `(syntax-ppss)` reports a string or comment.
4. Implement `LANG-beginning-of-defun` with support for positive, nil, and negative
   arguments by repeating the helper search for the requested count.
5. Implement `LANG-end-of-defun` only if needed; keep it conservative and based on the
   next definition start, a closing delimiter, or the end of buffer.
6. In `define-derived-mode`, set `beginning-of-defun-function` and optional
   `end-of-defun-function` with `setq-local`.
7. Add tests using the built-in `beginning-of-defun` and `end-of-defun` commands.
8. Run validation before applying the next skill.

## Tests

- Enable the mode in a temp buffer with at least two definitions.
- From inside a definition body, call `beginning-of-defun` and assert point lands on the
  expected definition start.
- If the skill adds `end-of-defun-function`, call `end-of-defun` and assert point moves
  to the expected end position.
- Include a definition-like token inside a string or comment and assert navigation
  ignores it.
- Keep earlier syntax and imenu tests passing.

## Anti-patterns

- Implementing a full parser for simple top-level navigation.
- Ignoring the `beginning-of-defun` argument contract.
- Matching definition-like text inside strings or comments.
- Mutating global defun navigation variables.
- Adding completion, Eldoc, xref, diagnostics, command runners, or formatters.
- Introducing non-built-in dependencies or external packages.

## Validation

```sh
make validate MODE_DIR=path/to/mode MODE=foo
```

Expected result: defun navigation tests pass and the mode byte-compiles.
