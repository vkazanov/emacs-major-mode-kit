# Skill: Add Format Command

## Goal

Add an interactive mode-local command that formats the current buffer or region with an
optional external formatter.

## When to use

Use when the language has a formatter that can read source text from stdin or format a
file and write formatted source text to stdout.

## Allowed files

- Generated mode file.
- Generated test file.
- Facts source when formatter facts need to be updated.
- Sample files used by format command tests.

## Built-in Emacs APIs

- `defun`
- `interactive`
- `executable-find`
- `call-process-region`
- `make-process`
- `replace-buffer-contents`
- `buffer-modified-p`
- `save-excursion`
- `use-region-p`
- `define-key`
- `ert-deftest`

## Requirements

- Store the formatter command and arguments in the facts source.
- Define a command such as `LANG-format-buffer` and make it `interactive`.
- Check the formatter with `executable-find` when the command runs; never run on load.
- Prefer `call-process-region` for simple synchronous stdin/stdout formatters.
- Use `make-process` only when the formatter must run asynchronously.
- Apply formatted output by replacing the buffer or region deliberately; use
  `replace-buffer-contents` for whole-buffer replacement when practical.
- Preserve point with `save-excursion` where practical.
- Report formatter failures with `user-error` and keep the original buffer unchanged.
- Bind the command only in the mode-local keymap when adding a keybinding.
- Do not add global keybindings.
- Do not install formatting into save hooks by default; formatting on save must remain
  an explicit user choice.

## Steps

1. Add or confirm formatter facts, including command name and required arguments.
2. If no formatter command is known, skip this skill and record the reason.
3. For common stdin/stdout formatter shape, adapt `templates/snippets/14-formatter.md`.
4. Define a helper that builds the formatter program and argument list without running
   the formatter.
5. Implement `LANG-format-buffer` or `LANG-format-region` as an interactive command.
6. Use `executable-find` at command time and signal `user-error` if the formatter is
   unavailable.
7. Capture formatter output in a temp buffer and replace the target buffer or region
   only after the formatter exits successfully.
8. Preserve point and avoid changing the buffer on non-zero formatter exit.
9. Add an optional mode-local keybinding in `LANG-mode-map`.
10. Add formatter helper and command tests, then run validation before applying the next
   skill.

## Tests

- Test formatter command and argument construction without running the real formatter.
- Test the missing-formatter path by stubbing `executable-find`.
- Test success and failure behavior by stubbing `call-process-region` or the formatter
  helper.
- Assert failed formatting leaves the original buffer text unchanged.
- Assert successful formatting changes only the intended buffer or region.
- Assert formatting is not installed into save hooks by default and any keybinding is
  only in the mode-local keymap.

## Anti-patterns

- Running formatters when the mode loads.
- Installing format-on-save by default.
- Replacing buffer text before confirming the formatter succeeded.
- Adding global keybindings.
- Depending on external packages.
- Mutating unrelated buffer or global state.

## Validation

```sh
make validate MODE_DIR=path/to/mode MODE=foo
```

Expected result: format command tests pass and the mode byte-compiles.
