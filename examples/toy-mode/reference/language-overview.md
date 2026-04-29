# Toy Language Overview

## Sources

| Source | URL or path | Retrieved | Used for | License notes |
|---|---|---|---|---|
| User-supplied repository example | `examples/toy-mode/samples/` | N/A | Syntax, highlighting, indentation, and imenu examples | Repository-local example |

## Scope

- Lisp prefix: toy
- Mode directory: examples/toy-mode
- Extension: toy
- Requested skills: 00-05, 17
- Supported subset: small brace-delimited language with functions, variables, comments, strings, keywords, builtins, indentation, and imenu.
- Explicitly unsupported: diagnostics, compilation, run commands, formatting, syntax propertize, and tree-sitter.

## Language Details

- comments: `//` line comments and `/* */` block comments.
- strings: double-quoted strings with backslash escapes.
- keywords: `else`, `func`, `if`, `let`, `return`.
- builtins: `print`.
- definitions: `func NAME` function definitions and `let NAME` variable definitions.
- indentation: brace-based indentation with offset 4.
- outline: none.
- defun navigation: none.
- completion: none.
- Eldoc: none.
- xref: none.
- diagnostics: none.
- compilation: none.
- run command: none.
- formatter: none.
- syntax propertize: none.
- tree-sitter: none.

## Fixtures

- samples: `samples/basic.toy`, `samples/font-lock.toy`, `samples/imenu.toy`, and `samples/indentation.toy`.
- tool-output fixtures: none.
- provenance notes: sample files are repository-local fixtures for the Toy subset.

## Skill Applicability

- applied: 00 create basic mode, 01 syntax table, 02 comments, 03 font lock, 04 indentation, 05 imenu, 17 polish package.
- skipped with reasons: optional skills 06-16 were not requested for the committed Toy example.
- pending or unknown: none.
