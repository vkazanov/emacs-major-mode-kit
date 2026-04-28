# Skill: Add Completion At Point

## Goal

Add a small `completion-at-point` backend for language keywords, builtins, and optional
current-buffer symbols.

## When to use

Use after syntax state is reliable and the facts file contains keyword, builtin, or
simple symbol data that should be offered as completions.

## Allowed files

- Generated mode file.
- Generated test file.
- Generated facts file when completion facts need to be updated.
- Sample files used by completion tests.

## Built-in Emacs APIs

- `completion-at-point-functions`
- `completion-at-point`
- `bounds-of-thing-at-point`
- `syntax-ppss`
- `thing-at-point`
- `completion-all-completions`
- `add-hook`
- `ert-deftest`

## Requirements

- Start with keywords and builtins from the facts file.
- Optionally include current-buffer symbols discovered with a conservative scan.
- Define a language-specific function such as `LANG-completion-at-point`.
- Add the function to `completion-at-point-functions` buffer-locally inside
  `define-derived-mode`.
- Use `bounds-of-thing-at-point` to find the completion bounds.
- Return normal CAPF data in the form `(START END COLLECTION . PROPS)`.
- Return `nil` inside strings or comments by checking `syntax-ppss`.
- Keep completion synchronous and in-memory.
- Do not depend on company, corfu, cape, or any other external packages.

## Steps

1. Add or confirm `:keywords` and `:builtins` facts.
2. Define a completion collection from those facts.
3. If useful, add a helper that collects current-buffer symbols and ignores strings and
   comments with `syntax-ppss`.
4. Implement `LANG-completion-at-point` using `bounds-of-thing-at-point`.
5. Return `(list start end collection :exclusive 'no)` or equivalent CAPF data when a
   completion prefix is present.
6. In `define-derived-mode`, add the function to `completion-at-point-functions` with
   a buffer-local `add-hook` call.
7. Add direct CAPF tests and run validation before applying the next skill.

## Tests

- Enable the mode and call `LANG-completion-at-point` at a partial identifier.
- Assert the returned start, end, and collection include expected keywords or builtins.
- Use `completion-all-completions` against the returned CAPF data when practical.
- Assert the CAPF returns `nil` in strings and comments.
- If current-buffer symbols are included, verify symbols from the current buffer appear
  and unrelated project files are not scanned.

## Anti-patterns

- Depending on company, corfu, cape, LSP clients, tags, or external packages.
- Scanning project directories for completion candidates.
- Running external processes or shell commands from completion.
- Returning completions inside strings or comments unless the language specifically
  requires that behavior.
- Replacing the global `completion-at-point-functions` value.
- Adding Eldoc, xref, diagnostics, command runners, or formatters.

## Validation

```sh
make test MODE_DIR=path/to/mode MODE=foo
make compile MODE_DIR=path/to/mode MODE=foo
make clean MODE_DIR=path/to/mode
```

Expected result: completion tests pass and the mode byte-compiles.
