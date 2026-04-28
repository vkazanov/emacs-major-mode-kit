# Agent Validation

Use this guide to check whether Codex and Claude Code can follow this repository's
instructions and create a generated major mode by applying skill documents.

## Instruction Loading

Validate instructions before asking an agent to write a mode.

For Codex, run from the repository root:

```sh
codex --ask-for-approval never "Summarize the current instructions."
```

Expected: Codex summarizes guidance from `AGENTS.md`, including skill order,
`MODE_DIR`/`MODE` validation, and Emacs 29+ built-ins.

For Claude Code, `CLAUDE.md` imports `AGENTS.md`. Start Claude Code from the repository
root and run `/memory`.

Expected: Claude Code lists `CLAUDE.md` and the imported `AGENTS.md` as loaded memory.

This checkout may not be a git repository. For Codex validation, launch from this
directory or from a real git checkout root so project instruction discovery is
predictable.

## Cross-Agent Trial Prompt

Run the same prompt in separate clean copies for Codex and Claude Code:

```text
Create examples/mini-hcl-mode for a Mini HCL language subset by applying skills 00
through 05 in order, then skill 17 as the final polish step. Use LANG=mini-hcl,
LANGNAME="Mini HCL", EXT=hcl, MODE_DIR=examples/mini-hcl-mode, MODE=mini-hcl.

Language facts:
- comments: #, //, and /* */
- strings: double-quoted with backslash quoting
- keywords: resource, variable, output, module, true, false
- builtins: file, join, length
- definitions: block declarations like resource "TYPE" "NAME", variable "NAME",
  output "NAME", and module "NAME"
- indentation: braces, offset 2

Add samples and ERT tests for mode activation, comments, strings, font-lock,
indentation, and imenu. Run validation after each skill, inline the facts file during
skill 17, and clean bytecode at the end.
```

Accept the result only if all commands pass:

```sh
make test MODE_DIR=examples/mini-hcl-mode MODE=mini-hcl
make compile MODE_DIR=examples/mini-hcl-mode MODE=mini-hcl
make polish-check MODE_DIR=examples/mini-hcl-mode MODE=mini-hcl
make clean MODE_DIR=examples/mini-hcl-mode
```

## Real-Language Targets

Use these subsets to test the basic procedure without committing to production-grade
language support.

- INI subset: `MODE=mini-ini`, `EXT=ini`; comments `#` and `;`; section imenu entries
  like `[database]`; zero indentation. This is the easiest smoke test.
- HCL/Terraform subset: `MODE=mini-hcl`, `EXT=hcl`; comments `#`, `//`, and `/* */`;
  double-quoted strings; brace indentation; imenu for block declarations. This is the
  primary cross-agent trial because it exercises all core skills.
- SQL DDL subset: `MODE=mini-sql`, `EXT=sql`; comments `--` and `/* */`; single-quoted
  strings; keyword highlighting; imenu for `CREATE TABLE name`; simple continuation or
  zero indentation. This checks a non-brace shape.

## Advanced Feature Prompt Shape

Use this compact shape when testing later optional skills. Replace placeholders with
real language facts; do not invent tools, grammars, or command output.

```text
Extend MODE_DIR for LANGNAME by applying skills 11 and 16 in ascending order, then
skill 17. The mode is already polished, so update the inlined LANG-facts constant and
do not recreate a runtime LANG-facts.el file.

Language facts:
- diagnostics: TOOL command, representative output, and severity mapping
- tree-sitter: grammar language symbol, query needs, and opt-in LANG-ts-mode policy

Add ERT tests that stub executable-find and tree-sitter readiness/setup functions.
The missing diagnostic tool path must call REPORT-FN with no diagnostics and must not
start a process. Run make test, make compile, and make clean with MODE_DIR and MODE
after each applied skill; after skill 17, also run make polish-check.
```

## Acceptance Checklist

Use this acceptance template for each agent run.

Record results with this template:

```markdown
## Agent

- Tool:
- Date:
- Prompt target:
- Instruction loading confirmed:
- Skills applied in order:
- Validation after each skill:
- Final `make test`:
- Final `make compile`:
- Final `make polish-check`:
- `make clean MODE_DIR=...` run:
- Facts file inlined:
- Unrelated edits:
- Notes:
```

The trial passes when the agent reads the instructions, opens the relevant skill files,
keeps `EXT` bare, edits only the generated files, avoids external dependencies and
global keybindings, inlines the final facts file into the mode file, and produces
passing tests, byte compilation, and polish checks.
