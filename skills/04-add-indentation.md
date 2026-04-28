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
- Facts source when indentation facts need to be updated.
- Sample files used by indentation tests.

## Built-in Emacs APIs

- `indent-line-function`
- `indent-line-to`
- `syntax-ppss`
- `back-to-indentation`
- `current-indentation`
- `indent-region`
- `line-beginning-position`
- `re-search-forward`
- `setq-local`
- `ert-deftest`

## Requirements

- Define a language-specific `LANG-indent-line`.
- Set `indent-line-function` buffer-locally inside `define-derived-mode`.
- Store an explicit indentation style and offset in the facts source when useful.
- Choose one common shape before implementing: `zero`, `brace`, `continuation`,
  `indentation-sensitive`, `choice-depth`, or another documented conservative rule.
- For `zero`, always indent to column 0.
- For `brace`, indent by brace depth and dedent lines beginning with a closing token.
- For `continuation`, indent continued statement lines by one offset from the statement
  start and dedent terminators such as `;`, `)`, `]`, or `}` when the language uses them.
- For `indentation-sensitive`, preserve existing meaningful indentation and only infer
  indentation for blank/new lines from nearby significant lines or exact block facts.
- For `choice-depth`, compute indentation from the depth of leading choice/list markers
  and any documented body-continuation rule.
- Ignore indentation markers inside strings and comments using `syntax-ppss`.
- Preserve point position where practical.
- Do not invoke formatter processes.

## Steps

1. Choose the simplest indentation rule that matches the language's current scope.
2. Update indentation facts, such as `:style brace` or `:style continuation` and
   `:offset 4`.
3. For common indentation shapes, adapt
   `templates/snippets/04-indentation-recipes.md`.
4. Implement a helper that calculates indentation for the current line.
5. Use `back-to-indentation` when checking whether a line starts with a closing,
   continuation, dedent, or choice marker.
6. Use `syntax-ppss` at candidate token positions so strings and comments do not
   affect indentation.
7. Implement `LANG-indent-line` with `indent-line-to`.
8. Set `indent-line-function` in the mode.
9. Add an `indent-region` fixture test.
10. Run validation before applying the next skill.

## Tests

- Add a multi-line fixture and call `indent-region`.
- Assert the final buffer string exactly.
- Include a string or comment containing an indentation marker to prove it is ignored
  for marker-based styles.
- Keep syntax and highlighting tests passing.

## Anti-patterns

- Calling formatter programs from indentation.
- Reindenting with broad text rewrites unrelated to the current line or region.
- Counting delimiters inside strings or comments.
- Adding imenu, command runners, or formatters.
- Introducing non-built-in dependencies.

## Validation

```sh
make validate MODE_DIR=path/to/mode MODE=foo
```

Expected result: indentation tests pass and the mode byte-compiles.
