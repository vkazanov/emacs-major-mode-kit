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
`skills/index.md`, source-backed intake for real languages, `MODE_DIR`/`MODE`
validation, optional-skill skips, the language overview, and Emacs 29+ built-ins.

For Claude Code, `CLAUDE.md` imports `AGENTS.md`. Start Claude Code from the repository
root and run `/memory`.

Expected: Claude Code lists `CLAUDE.md` and the imported `AGENTS.md` as loaded memory.

This checkout may not be a git repository. For validation, launch from this directory
or from a real git checkout root so project instruction discovery is predictable.

## Cross-Agent Trial Prompt

Run the same prompt in separate clean copies for Codex and Claude Code:

```text
Create examples/mini-hcl-mode for a Mini HCL language subset by applying skills 00
through 05 in order, then skill 17 as the final polish step. Use LANG=mini-hcl,
LANGNAME="Mini HCL", EXT=hcl, MODE_DIR=examples/mini-hcl-mode, MODE=mini-hcl.

Language details:
- comments: #, //, and /* */
- strings: double-quoted with backslash quoting
- keywords: resource, variable, output, module, true, false
- builtins: file, join, length
- definitions: block declarations like resource "TYPE" "NAME", variable "NAME",
  output "NAME", and module "NAME"
- indentation: braces, offset 2

Create reference/language-overview.md. Add samples and ERT tests for mode activation,
comments, strings, font-lock, indentation, and imenu. Run validation after each
applied skill and clean bytecode at the end.
```

Accept the result only if this passes:

```sh
make validate-polished MODE_DIR=examples/mini-hcl-mode MODE=mini-hcl
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
  strings; keyword highlighting; imenu for `CREATE TABLE name`; statement-continuation
  indentation. This checks a non-brace shape.

## Source-Backed Trial Prompt

Use this shape when testing a real language whose details are not all supplied:

```text
Create examples/test-LANG-mode for LANGNAME using official language documentation.
First complete the source-backed intake from docs/real-language-intake.md. Record
official sources in MODE_DIR/reference/language-overview.md, create small curated
fixtures under MODE_DIR/samples/, then apply the broadest applicable skill set. Do
not invent formatter commands, diagnostics, run commands, or tree-sitter grammars;
record skipped optional skills with reasons. Finish with skill 17 and run make
validate-polished.
```

The trial passes only if the agent records sources, creates small fixtures, applies
only justified optional skills, documents skipped optional skills, and validates the
polished mode.

## Advanced Feature Prompt Shape

Use this compact shape when testing later optional skills. Replace placeholders with
real language details; do not invent tools, grammars, or command output.

```text
Extend MODE_DIR for LANGNAME by applying skills 11 and 16 in ascending order, then
skill 17.

Language details:
- diagnostics: TOOL command, representative output, and severity mapping
- tree-sitter: grammar language symbol, query needs, and opt-in LANG-ts-mode policy

Update reference/language-overview.md. Add ERT tests that stub executable-find and
tree-sitter readiness/setup functions. The missing diagnostic tool path must call
REPORT-FN with no diagnostics and must not start a process. Run make validate after
each non-final applied skill; after skill 17, run make validate-polished.
```

## Skip-Semantics Checks

Use these dry-run review scenarios to check optional-skill policy:

- `00-17` with no formatter and no known tree-sitter grammar should skip skills `14`
  and `16` with reasons in the overview.
- Sparse `14` with no formatter should ask once for formatter details, then skip if
  they remain absent.
- Sparse `16` with a known grammar that is not installed locally may create
  `LANG-ts-mode.el`, but tests must stub missing grammar behavior.
- Tool-backed skills with known commands absent locally should use command-time checks
  and stubbed tests, not load-time failures.

## Acceptance Checklist

Use this acceptance template for each agent run.

Record results with this template:

```markdown
## Agent

- Tool:
- Date:
- Prompt target:
- Instruction loading confirmed:
- Language overview created:
- Sources recorded:
- Fixture provenance:
- Skills applied in order:
- Skills skipped with reasons:
- Validation after each applied skill:
- Final `make validate-polished`:
- Unrelated edits:
- Notes:
```

The trial passes when the agent reads the instructions, opens the relevant skill files,
uses `skills/index.md` for planning, keeps `EXT` bare, edits only the generated files,
avoids external dependencies and global keybindings, creates the language overview,
and produces passing validation.
