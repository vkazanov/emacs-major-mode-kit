# Completion At Point Snippet

Skill: `08-add-completion-at-point.md`

Use for static candidates and optional current-buffer symbols.

```elisp
(defconst LANG--completion-static-candidates
  (append LANG--keywords LANG--builtins)
  "Static completion candidates for LANGNAME.")

(defun LANG-completion-candidates ()
  "Return completion candidates for the current LANGNAME buffer."
  (delete-dups (copy-sequence LANG--completion-static-candidates)))

(defun LANG-completion-at-point ()
  "Return completion data for LANGNAME at point."
  (unless (nth 8 (syntax-ppss))
    (when-let* ((bounds (bounds-of-thing-at-point 'symbol))
                (start (car bounds))
                (end (cdr bounds)))
      (list start end (LANG-completion-candidates) :exclusive 'no))))
```

Mode setup:

```elisp
(add-hook 'completion-at-point-functions #'LANG-completion-at-point nil t)
```

Test candidates directly and assert the backend returns `nil` in strings/comments.
