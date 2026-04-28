# Syntax Table Snippet

Skill: `01-add-syntax-table.md`

Use when the language has C-style comments, `#` line comments, double strings, or
backslash escaping that syntax table entries can model.

```elisp
(defvar LANG-mode-syntax-table
  (let ((table (make-syntax-table)))
    ;; // line comments and /* */ block comments.
    (modify-syntax-entry ?/ ". 124b" table)
    (modify-syntax-entry ?* ". 23" table)
    (modify-syntax-entry ?\n "> b" table)
    ;; Optional single-character line comment opener.
    (modify-syntax-entry ?# "< b" table)
    ;; Double-quoted strings and backslash escaping.
    (modify-syntax-entry ?\" "\"" table)
    (modify-syntax-entry ?\\ "\\" table)
    table)
  "Syntax table for `LANG-mode'.")
```

Test fragment:

```elisp
(with-temp-buffer
  (insert "// comment\n\"not // comment\"\n")
  (LANG-mode)
  (search-forward "comment")
  (should (nth 4 (syntax-ppss)))
  (search-forward "not")
  (should (nth 3 (syntax-ppss))))
```

Do not use for context-sensitive strings/comments that require skill `15`.
