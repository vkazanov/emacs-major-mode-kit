# Skill: Add Run Command

## Goal

Add an interactive mode-local command that runs the current file or project command in
an Emacs compilation buffer.

## When to use

Use when the language has an interpreter, runtime, test runner, or compiler command
that users should be able to invoke from the major mode.

## Allowed files

- Generated mode file.
- Generated test file.
- Generated facts file when run tool facts need to be updated.
- Sample files used by run command tests.

## Built-in Emacs APIs

- `defun`
- `interactive`
- `compile`
- `compilation-start`
- `compile-command`
- `executable-find`
- `buffer-file-name`
- `file-name-nondirectory`
- `shell-quote-argument`
- `define-key`
- `ert-deftest`

## Requirements

- Store runtime, compiler, or test runner commands in the facts file.
- Define a command such as `LANG-run` and make it `interactive`.
- Check tools with `executable-find` when the command runs; never run on load.
- Build shell commands with `shell-quote-argument` for file names and user-controlled
  arguments.
- Use `compile` or `compilation-start` so output uses compilation navigation.
- Reuse the skill 12 compilation mode when the run output needs custom error matching.
- Bind the command only in the mode-local keymap when adding a keybinding.
- Do not add global keybindings.
- Do not run the command automatically from hooks, save operations, or mode activation.

## Steps

1. Add or confirm run tool facts such as interpreter, runner, or compiler command.
2. Define a helper that builds the run command string from `buffer-file-name` and facts.
3. Make the helper signal a clear `user-error` when there is no current file or the tool
   is missing.
4. Implement `LANG-run` as an interactive command that calls `compile` or
   `compilation-start`.
5. If needed, pass the language compilation mode from skill 12 to `compilation-start`.
6. Add an optional mode-local keybinding in `LANG-mode-map`.
7. Add command-construction and interactive-command tests, then run validation before
   applying the next skill.

## Tests

- Test command construction for a normal file and a file name requiring quoting.
- Test the missing-tool path by stubbing `executable-find`.
- Test the missing-file path in a temp buffer without `buffer-file-name`.
- Test the interactive command with `compile` or `compilation-start` stubbed so no real
  external process runs.
- Assert any keybinding is present only in the mode-local keymap.

## Anti-patterns

- Running interpreters, compilers, or tests when the mode loads.
- Adding global keybindings.
- Building shell commands from unquoted file names.
- Installing run commands into save hooks.
- Bypassing compilation buffers when compiler-style output should support `next-error`.
- Depending on external packages.

## Validation

```sh
make test MODE_DIR=path/to/mode MODE=foo
make compile MODE_DIR=path/to/mode MODE=foo
make clean MODE_DIR=path/to/mode
```

Expected result: run command tests pass and the mode byte-compiles.
