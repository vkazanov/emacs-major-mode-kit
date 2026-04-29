# Language Overview

Every generated mode has one durable, human-readable language overview at
`MODE_DIR/reference/language-overview.md`. The overview is created from
`templates/language-overview.md` by skill `00` and is updated when later skills learn
or correct language knowledge.

Generated Emacs Lisp must not contain a central language overview object. Runtime
files should define only the narrow constants and helpers required by applied
features, such as keyword lists, definition regexps, syntax tables, command builders,
or tree-sitter language symbols.

## Sections

- `Sources`: official docs, local references, retrieval dates, use, and license notes.
- `Scope`: prefix, directory, extension, requested skills, supported subset, and
  unsupported areas.
- `Language Details`: comments, strings, keywords, builtins, definitions,
  indentation, editor services, tools, syntax-propertize cases, and tree-sitter notes.
- `Fixtures`: sample files, tool-output fixtures, and provenance notes.
- `Skill Applicability`: applied skills, skipped optional skills with reasons, and
  unknown/pending work.

The overview is intentionally not parsed by generated packages. Keep it concise enough
for agents and maintainers to review, and keep large copied samples in `samples/` or
tool-output fixture files instead of embedding them in Markdown.
