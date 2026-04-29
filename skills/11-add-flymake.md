# Skill: Add Flymake

## Goal

Add optional Flymake diagnostics backed by a language checker, compiler, or linter.
The backend should run asynchronously, report diagnostics through Flymake, and do
no external process work when the tool is unavailable.

## When to use

Use after the mode has reliable syntax state and the language overview identifies an external
diagnostic tool or compiler output format for the language.

## Allowed files

- Generated mode file.
- Generated test file.
- Language overview when diagnostic tool details need to be updated.
- Sample files or diagnostic output fixtures used by Flymake tests.

## Built-in Emacs APIs

- `flymake-diagnostic-functions`
- `flymake-make-diagnostic`
- `flymake-mode`
- `executable-find`
- `make-process`
- `process-live-p`
- `kill-process`
- `process-buffer`
- `add-hook`
- `ert-deftest`

## Requirements

- Require only built-in libraries such as `flymake` and `subr-x` when needed.
- Store the checker or compiler command in the language overview.
- Define a language-specific backend such as `LANG-flymake-backend`.
- Add the backend to `flymake-diagnostic-functions` buffer-locally inside
  `define-derived-mode`.
- Check tools with `executable-find` when the backend runs; never run on load.
- If `executable-find` reports that the optional tool is unavailable, call
  `REPORT-FN` with an empty diagnostic list and return promptly without starting a
  process.
- Return quickly from the backend and use `make-process` for external diagnostics.
- Keep a buffer-local process variable and cancel any previous live process before
  starting a new one.
- Ignore stale process output by checking that the process is still the current
  buffer-local process before calling the Flymake report function.
- Parse diagnostic output in a separate helper and create diagnostics with
  `flymake-make-diagnostic`.
- Do not enable `flymake-mode` automatically unless the user explicitly asks for that
  behavior in the generated mode.

## Steps

1. Add or confirm tool details for the checker command and diagnostic output format.
2. For common asynchronous process shape, adapt
   `templates/snippets/11-flymake-process.md`.
3. Define a buffer-local variable such as `LANG--flymake-process`.
4. Implement a parser helper that converts checker output into line, column, severity,
   and message data.
5. Implement a helper that converts parsed diagnostics to `flymake-make-diagnostic`
   objects for the current buffer.
6. Implement `LANG-flymake-backend` with the Flymake `REPORT-FN` argument and ignored
   keyword arguments.
7. In the backend, check `executable-find`. When the tool is unavailable, call
   `REPORT-FN` with `nil` and do not start a process. Otherwise cancel the previous
   process, start a new asynchronous `make-process`, and report only non-stale
   results.
8. In `define-derived-mode`, add the backend with a buffer-local `add-hook` call.
9. Add parser and backend tests, then run validation before applying the next skill.

## Tests

- Test diagnostic parsing directly with fixture output from the checker.
- Test conversion to `flymake-make-diagnostic` objects for warning and error cases.
- Test that the backend calls `REPORT-FN` with no diagnostics and returns promptly
  when `executable-find` reports no tool.
- Test cancellation or stale process handling with a stubbed process path when practical.
- Do not require the real external checker to be installed for ERT tests.

## Anti-patterns

- Running diagnostic tools when the mode loads.
- Using synchronous `call-process` for normal Flymake checks.
- Reporting stale process output after a newer check has started.
- Leaving previous processes running without cancellation.
- Enabling `flymake-mode` automatically without an explicit generated-mode decision.
- Depending on external packages or language servers.

## Validation

```sh
make validate MODE_DIR=path/to/mode MODE=foo
```

Expected result: Flymake parser and backend tests pass and the mode byte-compiles.
