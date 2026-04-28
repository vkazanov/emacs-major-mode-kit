# Comment Variables Snippet

Skill: `02-add-comments.md`

Use after syntax state already recognizes comments.

```elisp
(setq-local comment-start "// ")
(setq-local comment-end "")
(setq-local comment-start-skip "\\(?://+\\|#+\\|/\\*+\\)\\s *")
(setq-local comment-use-syntax t)
```

Test fragment:

```elisp
(with-temp-buffer
  (insert "value\n")
  (LANG-mode)
  (should (equal comment-start "// "))
  (comment-region (point-min) (point-max))
  (should (string-prefix-p "// " (buffer-string))))
```

Choose one primary `comment-start`; include all supported openers in
`comment-start-skip`.
