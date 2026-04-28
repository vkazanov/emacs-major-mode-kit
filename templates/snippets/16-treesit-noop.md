# Tree-Sitter No-Op Snippet

Skill: `16-add-treesit-mode.md`

Use only when the tree-sitter language symbol is known. `LANG-ts-mode.el` should
require `LANG-mode` and `treesit`; after polish it reads inlined facts through
`LANG-mode`.

```elisp
(require 'treesit)
(require 'LANG-mode)

;;;###autoload
(define-derived-mode LANG-ts-mode LANG-mode "LANGNAME[TS]"
  "Tree-sitter mode for LANGNAME."
  (if (not (treesit-ready-p 'LANG t))
      (setq-local treesit-font-lock-settings nil)
    (treesit-parser-create 'LANG)
    ;; Set tree-sitter locals here, then run setup.
    (treesit-major-mode-setup)))
```

Tests should stub `treesit-ready-p`, `treesit-parser-create`, and
`treesit-major-mode-setup`. Do not download or install grammars during mode load.
