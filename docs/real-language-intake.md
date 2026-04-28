# Real-Language Intake

Use this pre-step before skill `00` when the requested mode targets a real language and
the user has not supplied enough facts. This is not a numbered skill; it prepares the
facts used by the skill sequence.

## Workflow

1. Identify official sources first: language manual, reference implementation docs,
   compiler/tool docs, and official examples.
2. Record source URLs, retrieval date, license notes, and why each source was used in
   `MODE_DIR/reference/sources.md` when durable provenance is useful.
3. Extract only facts needed for the requested range: comments, strings, keywords,
   builtins, definition forms, indentation, tool commands, output formats, formatter,
   syntax-propertize needs, and tree-sitter grammar symbol.
4. Create small curated fixtures under `MODE_DIR/samples/`. Prefer tiny hand-written
   examples derived from the docs over copying large upstream files.
5. Decide optional-skill applicability before skill `00`. Record unknown or unsupported
   optional features as skipped with reasons; do not invent tool commands, diagnostic
   formats, formatters, grammars, or language semantics.

## Source Rules

- Prefer official documentation and official examples.
- If network access is unavailable, use already-provided local docs or ask for the
  missing language facts that cannot be discovered locally.
- Keep copied third-party sample text small and license-aware.
- Use representative tool-output fixtures for tests, not a required installed tool.

## Output

The intake should produce a filled bootstrap fact list and, for broad end-to-end runs,
a short source note file. The facts feed `AGENTS.md`'s bootstrap prompt; the source
note stays package-local and is not part of the runtime mode.
