# Skill: Create Basic Mode

## Goal

Create the initial generated language package from the templates: mode file, test file,
and facts source. The result should load, derive from `prog-mode`, associate the bare
extension with the mode, and pass a basic activation test.

## When to use

Use this first, before adding syntax tables, comments, highlighting, indentation,
imenu, diagnostics, navigation backends, parser variants, commands, or tool integrations.

## Allowed files

- Generated mode file, such as `foo-mode.el`.
- Generated test file, such as `foo-mode-test.el`.
- Facts source, such as `foo-facts.el`.
- Optional sample files only when needed by the basic load test.

## Built-in Emacs APIs

- `define-derived-mode`
- `prog-mode`
- `defgroup`
- `defcustom`
- `make-sparse-keymap`
- `add-to-list`
- `auto-mode-alist`
- `derived-mode-p`
- `ert-deftest`

## Requirements

- Instantiate `templates/lang-mode.el`, `templates/lang-mode-test.el`, and
  `templates/lang-facts.el`.
- Replace `LANG` with the Lisp prefix, such as `foo`.
- Replace `LANGNAME` with the human-readable language name, such as `Foo`.
- Replace `EXT` with the bare extension, such as `foo`, never `.foo`.
- Keep lexical binding, Commentary, Code, `provide`, and file footer sections.
- Define a local `LANG-mode-map`; do not add global keybindings.
- Keep placeholder syntax table, font-lock keywords, and indentation function minimal.
- Register file association with an autoloaded `auto-mode-alist` entry.
- Do not add feature behavior owned by later skills.

## Steps

1. Copy the three templates into the generated mode directory and rename them for the
   language prefix.
2. Replace placeholders consistently in filenames, symbols, docstrings, feature names,
   and the file association regexp.
3. Fill the facts source with at least `:language` and `:extensions`; leave unknown facts
   as `nil`.
4. Ensure the mode derives from `prog-mode` and sets only the placeholder local behavior
   from the template.
5. Add or update the basic ERT test to create a temp buffer, enable the mode, and assert
   `(derived-mode-p 'LANG-mode)`.
6. Run validation before applying the next skill.

## Tests

- Add a `LANG-mode-basic-test` that enables the mode in a temp buffer.
- Assert `(derived-mode-p 'LANG-mode)`.
- Load the mode and test file in `emacs -Q --batch`.

## Anti-patterns

- Adding highlighting, syntax classification, indentation logic, imenu, diagnostics,
  navigation backends, parser variants, command runners, or formatters in this step.
- Editing unrelated repository files.
- Introducing non-built-in dependencies.
- Using `EXT` with a leading dot.
- Adding global keybindings or advice.

## Validation

```sh
make validate MODE_DIR=path/to/mode MODE=foo
```

Expected result: the basic ERT test passes and the mode byte-compiles.
