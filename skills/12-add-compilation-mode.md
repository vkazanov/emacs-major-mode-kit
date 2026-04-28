# Skill: Add Compilation Mode

## Goal

Teach Emacs compilation buffers how to recognize the language tool's error and warning
output so `next-error` can visit source locations.

## When to use

Use when the language has a compiler, checker, build tool, or test runner whose output
contains file, line, column, warning, or error locations.

## Allowed files

- Generated mode file.
- Generated test file.
- Generated facts file when compilation tool facts need to be updated.
- Sample compilation output fixtures used by tests.

## Built-in Emacs APIs

- `compile`
- `compilation-mode`
- `define-compilation-mode`
- `compilation-start`
- `compile-command`
- `compilation-error-regexp-alist`
- `compilation-error-regexp-alist-alist`
- `executable-find`
- `shell-quote-argument`
- `setq-local`
- `ert-deftest`

## Requirements

- Require only the built-in `compile` library when needed.
- Store compiler or checker commands in the facts file.
- Prefer existing entries from `compilation-error-regexp-alist-alist` when they match
  the tool output.
- Add custom regexps only when built-in compilation patterns are insufficient.
- Do not mutate global `compilation-error-regexp-alist` or
  `compilation-error-regexp-alist-alist`.
- For custom patterns, define a language-specific compilation mode with
  `define-compilation-mode` and set `compilation-error-regexp-alist` buffer-locally.
- Set `compile-command` buffer-locally inside `define-derived-mode` only when a useful
  default command can be built without running tools.
- Check tools with `executable-find` before interactive commands run; never run on load.
- Quote file names and user-controlled command arguments with `shell-quote-argument`.

## Steps

1. Add or confirm tool facts for the compiler, checker, or build command.
2. Collect representative output lines and identify file, line, column, and severity
   captures.
3. Reuse an existing `compilation-error-regexp-alist-alist` symbol when it fits.
4. If needed, define `LANG-compilation-error-regexp-alist` with explicit regexp entries.
5. If custom entries are needed, define `LANG-compilation-mode` with
   `define-compilation-mode` and set `compilation-error-regexp-alist` buffer-locally.
6. Define a helper that builds a default `compile-command` string without executing it.
7. In `define-derived-mode`, set `compile-command` buffer-locally when appropriate.
8. Add tests for command construction and regexp matching, then run validation before
   applying the next skill.

## Tests

- Test the custom regexp against sample error and warning lines.
- Assert file, line, column, and severity captures match the documented output format.
- Test the default `compile-command` builder quotes file names with
  `shell-quote-argument`.
- If a custom compilation mode is added, enable it in a temp buffer and assert the
  buffer-local `compilation-error-regexp-alist`.
- Do not require the real external compiler or checker to be installed for ERT tests.

## Anti-patterns

- Running compilers, checkers, or build tools when the mode loads.
- Mutating global compilation regexp variables from a generated mode.
- Adding custom regexps when existing built-in compilation patterns already work.
- Building shell commands by concatenating unquoted file names.
- Adding global keybindings.
- Depending on external packages.

## Validation

```sh
make test MODE_DIR=path/to/mode MODE=foo
make compile MODE_DIR=path/to/mode MODE=foo
make clean MODE_DIR=path/to/mode
```

Expected result: compilation regexp and command tests pass and the mode byte-compiles.
