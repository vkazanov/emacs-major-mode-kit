# Skill: Add Eldoc

## Goal

Show small, static language documentation in Eldoc for known keywords, builtins,
functions, or forms.

## When to use

Use after syntax state is reliable and the language overview contains documentation strings or
enough static metadata to derive short documentation.

## Allowed files

- Generated mode file.
- Generated test file.
- Language overview when documentation details need to be updated.
- Sample files used by Eldoc tests.

## Built-in Emacs APIs

- `eldoc-documentation-functions`
- `eldoc`
- `thing-at-point`
- `bounds-of-thing-at-point`
- `syntax-ppss`
- `add-hook`
- `ert-deftest`

## Requirements

- Store reusable documentation data in the language overview.
- Define a language-specific function such as `LANG-eldoc-function`.
- Add the function to `eldoc-documentation-functions` buffer-locally inside
  `define-derived-mode`.
- Follow Emacs 29 Eldoc callback conventions: the function receives `CALLBACK`, may
  return a string quickly, may call `CALLBACK` immediately, or may return `nil` for no
  documentation.
- Return promptly for no-doc cases.
- Use only static strings or documentation derived from the language overview.
- Return `nil` inside strings or comments unless the language specifically documents
  content there.
- Do not make network requests, start process objects, or run shell commands.

## Steps

1. Add documentation details, such as keyword descriptions or builtin signatures.
2. For common static Eldoc shape, adapt `templates/snippets/09-eldoc.md`.
3. Implement a helper that identifies the symbol at point with `thing-at-point` or
   `bounds-of-thing-at-point`.
4. Reject string and comment contexts with `syntax-ppss`.
5. Implement `LANG-eldoc-function` with a `CALLBACK` argument and optional ignored
   extra arguments.
6. Return a short documentation string for known symbols and `nil` otherwise.
7. In `define-derived-mode`, add the function to `eldoc-documentation-functions` with
   a buffer-local `add-hook` call.
8. Add direct tests for the documentation function and run validation before applying
   the next skill.

## Tests

- Enable the mode, place point on a documented symbol, and call the doc function
  directly with a callback.
- Assert the returned string or callback value matches the expected documentation.
- Place point on an unknown symbol and assert the function returns `nil` promptly.
- Assert the function returns `nil` inside strings and comments unless documented
  string/comment behavior is intentional.
- Keep completion and earlier tests passing when present.

## Anti-patterns

- Fetching documentation over the network.
- Starting a process, shell command, language server, or external tool from Eldoc.
- Computing documentation by scanning project directories.
- Returning long multi-paragraph reference text.
- Replacing the global `eldoc-documentation-functions` value.
- Depending on external packages.

## Validation

```sh
make validate MODE_DIR=path/to/mode MODE=foo
```

Expected result: Eldoc tests pass and the mode byte-compiles.
