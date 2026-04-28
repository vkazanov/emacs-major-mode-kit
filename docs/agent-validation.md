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
through 05 in order. Use LANG=mini-hcl, LANGNAME="Mini HCL", EXT=hcl,
MODE_DIR=examples/mini-hcl-mode, MODE=mini-hcl.

Language facts:
- comments: #, //, and /* */
- strings: double-quoted with backslash quoting
- keywords: resource, variable, output, module, true, false
- builtins: file, join, length
- definitions: block declarations like resource "TYPE" "NAME", variable "NAME",
  output "NAME", and module "NAME"
- indentation: braces, offset 2

Add samples and ERT tests for mode activation, comments, strings, font-lock,
indentation, and imenu. Run validation after each skill and clean bytecode at the end.
```

Accept the result only if both commands pass:

```sh
make test MODE_DIR=examples/mini-hcl-mode MODE=mini-hcl
make compile MODE_DIR=examples/mini-hcl-mode MODE=mini-hcl
make clean
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
- `make clean` run:
- Unrelated edits:
- Notes:
```

The trial passes when the agent reads the instructions, opens the relevant skill files,
keeps `EXT` bare, edits only the generated files, avoids external dependencies and
global keybindings, and produces passing tests and byte compilation.
