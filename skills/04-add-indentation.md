# Skill: Add Indentation

## Goal

Add a small `indent-line-function` for the language. Prefer predictable indentation
over clever parsing, and ignore syntax inside strings and comments.

## When to use

Use after `01-add-syntax-table.md`, because indentation needs reliable
`syntax-ppss` state for strings and comments.

## Allowed files

- Generated mode file.
- Generated test file.
- Generated facts file when indentation facts need to be updated.
- Sample files used by indentation tests.

## Built-in Emacs APIs

- `indent-line-function`
- `indent-line-to`
- `syntax-ppss`
- `back-to-indentation`
- `indent-region`
- `line-beginning-position`
- `setq-local`
- `ert-deftest`

## Requirements

- Define a language-specific `LANG-indent-line`.
- Set `indent-line-function` buffer-locally inside `define-derived-mode`.
- Store indentation style and offset in the facts file when useful.
- For brace languages, indent by brace depth and dedent lines beginning with `}`.
- Ignore braces or indentation markers inside strings and comments using `syntax-ppss`.
- Preserve point position where practical.
- Do not invoke formatter processes.

## Steps

1. Choose the simplest indentation rule that matches the language's current scope.
2. Update indentation facts, such as `:style braces` and `:offset 4`.
3. Implement a helper that calculates indentation for the current line.
4. Use `back-to-indentation` when checking whether a line starts with a closing token.
5. Use `syntax-ppss` at candidate token positions so strings and comments do not affect
   indentation.
6. Implement `LANG-indent-line` with `indent-line-to`.
7. Set `indent-line-function` in the mode.
8. Add an `indent-region` fixture test.
9. Run validation before applying the next skill.

## Tests

- Add a multi-line fixture and call `indent-region`.
- Assert the final buffer string exactly.
- Include a string or comment containing a brace-like token to prove it is ignored.
- Keep syntax and highlighting tests passing.

## Anti-patterns

- Calling formatter programs from indentation.
- Reindenting with broad text rewrites unrelated to the current line or region.
- Counting delimiters inside strings or comments.
- Adding imenu, command runners, or formatters.
- Introducing non-built-in dependencies.

## Validation

```sh
make test MODE_DIR=path/to/mode MODE=foo
make compile MODE_DIR=path/to/mode MODE=foo
make clean MODE_DIR=path/to/mode
```

Expected result: indentation tests pass and the mode byte-compiles.
