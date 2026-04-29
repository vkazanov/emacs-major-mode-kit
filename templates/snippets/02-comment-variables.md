# Comment Variables Snippet

Skill: `02-add-comments.md`

Use after syntax state already recognizes comments.

Common opener details:

| delimiter | kind | `comment-start` example | `comment-end` |
|---|---|---|---|
| `//` | line | `"// "` | `""` |
| `#` | line | `"# "` | `""` |
| `--` | line | `"-- "` | `""` |
| `;` | line | `"; "` | `""` |
| `;;` | line | `";; "` | `""` |
| `/* */` | block | `"/* "` | `" */"` |
| `<!-- -->` | block | `"<!-- "` | `" -->"` |
| `"""` | documented block/doc comment only | `"\"\"\""` | `"\"\"\""` |

If triple quotes are string delimiters in the target language, handle them as strings
or with syntax propertize, not comment variables.

For line-primary languages with optional block comments:

```elisp
(defconst LANG--comment-openers '("//" "#" "--" ";;" ";" "/*")
  "Comment openers recognized by `LANG-mode'.")

(setq-local comment-start "-- ")
(setq-local comment-end "")
(setq-local comment-start-skip
            (concat "\\(?:" (regexp-opt LANG--comment-openers) "\\)\\s *"))
(setq-local comment-use-syntax t)
```

For block-only languages:

```elisp
(setq-local comment-start "<!-- ")
(setq-local comment-end " -->")
(setq-local comment-start-skip (concat "\\(?:" (regexp-opt '("<!--")) "\\)\\s *"))
(setq-local comment-use-syntax t)
```

Test fragment:

```elisp
(with-temp-buffer
  (insert "value\n")
  (LANG-mode)
  (should (equal comment-start "-- "))
  (comment-region (point-min) (point-max))
  (should (string-prefix-p "-- " (buffer-string))))
```

Choose one primary `comment-start`; include all supported openers in
`comment-start-skip`. Use `regexp-opt` or carefully escaped literal regexps instead
of hand-rolled alternation for multi-character delimiters. Keep `comment-use-syntax`
only when syntax tests prove those comments are recognized.
