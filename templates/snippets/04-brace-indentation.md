# Brace Indentation Snippet

Skill: `04-add-indentation.md`

Use for conservative brace-depth indentation where braces inside strings/comments must
be ignored.

```elisp
(defun LANG--brace-depth-before (pos)
  "Return LANGNAME brace depth before POS, ignoring strings and comments."
  (save-excursion
    (let ((depth 0))
      (goto-char (point-min))
      (while (re-search-forward "[{}]" pos t)
        (let ((brace (char-after (match-beginning 0)))
              (brace-pos (match-beginning 0)))
          (unless (save-excursion (nth 8 (syntax-ppss brace-pos)))
            (setq depth (if (eq brace ?{) (1+ depth) (max 0 (1- depth)))))))
      depth)))

(defun LANG--line-closes-block-p ()
  "Return non-nil if the current LANGNAME line starts with a closing brace."
  (save-excursion
    (back-to-indentation)
    (and (looking-at-p "}")
         (not (nth 8 (syntax-ppss))))))

(defun LANG-calculate-indentation ()
  "Return indentation column for the current LANGNAME line."
  (let ((depth (LANG--brace-depth-before (line-beginning-position))))
    (* LANG-indent-offset
       (if (LANG--line-closes-block-p) (max 0 (1- depth)) depth))))
```

Test with `indent-region` on a complete fixture and include braces inside strings or
comments.
