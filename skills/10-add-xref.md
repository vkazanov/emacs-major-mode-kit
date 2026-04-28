# Skill: Add Current-Buffer Xref

## Goal

Add a minimal xref backend that resolves identifiers to definitions in the current
buffer only.

## When to use

Use after the mode has reliable syntax state and reusable definition facts, and after
imenu or defun navigation has proven the definition regexp is conservative enough.

## Allowed files

- Generated mode file.
- Generated test file.
- Generated facts file when xref definition facts need to be updated.
- Sample files used by xref tests.

## Built-in Emacs APIs

- `xref-backend-functions`
- `xref-backend-identifier-at-point`
- `xref-backend-definitions`
- `cl-defmethod`
- `xref-make`
- `xref-make-file-location`
- `thing-at-point`
- `syntax-ppss`
- `add-hook`
- `ert-deftest`

## Requirements

- Require only built-in libraries such as `cl-lib` and `xref` when needed.
- Store reusable definition regexps and name captures in the facts file.
- Define a language-specific backend function such as `LANG-xref-backend`.
- Add the backend function to `xref-backend-functions` buffer-locally inside
  `define-derived-mode`.
- Define minimal `cl-defmethod` implementations for
  `xref-backend-identifier-at-point` and `xref-backend-definitions`.
- Use `xref-make` and `xref-make-file-location` for returned xref items.
- Search only the current buffer for definitions.
- Skip candidate definitions inside strings or comments with `syntax-ppss`.
- Return `nil` when no definition is found.

## Steps

1. Add or confirm definition facts with a capture group for the definition name.
2. Require `xref` and `cl-lib` in the mode file if they are not already available.
3. Define `LANG-xref-backend` to return a backend symbol such as `LANG`.
4. Implement `xref-backend-identifier-at-point` for that backend using
   `thing-at-point`.
5. Implement a current-buffer definition search helper that compares captured names to
   the requested identifier and ignores string/comment matches with `syntax-ppss`.
6. Implement `xref-backend-definitions` to return xref items made with `xref-make` and
   `xref-make-file-location`.
7. In `define-derived-mode`, add the backend function to `xref-backend-functions` with
   a buffer-local `add-hook` call.
8. Add tests that call backend functions and methods directly where practical.
9. Run validation before applying the next skill.

## Tests

- Enable the mode in a buffer containing at least two definitions and references.
- Assert `LANG-xref-backend` returns the expected backend symbol.
- Place point on an identifier and call `xref-backend-identifier-at-point`.
- Call `xref-backend-definitions` directly and assert it returns the expected xref item.
- Verify definition-like text inside strings or comments is ignored.
- Assert only current-buffer definitions are considered; Project-wide lookup belongs to
  a later or separate feature.

## Anti-patterns

- Project-wide scanning, persistent symbol databases, tags files, LSP clients, or
  external packages.
- Running external processes from xref lookup.
- Adding completion, Eldoc, diagnostics, command runners, or formatters.
- Mutating global `xref-backend-functions`.
- Returning locations for definition-like text inside strings or comments.
- Building a parser when a conservative current-buffer regexp is enough.

## Validation

```sh
make test MODE_DIR=path/to/mode MODE=foo
make compile MODE_DIR=path/to/mode MODE=foo
```

Expected result: xref tests pass and the mode byte-compiles.
