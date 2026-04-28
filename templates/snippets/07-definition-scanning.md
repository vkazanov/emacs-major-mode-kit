# Definition Scanning Snippet

Skills: `07-add-beginning-end-of-defun.md`, `10-add-xref.md`

Use when definition matches are regular enough for current-buffer regexps.

```elisp
(defconst LANG--definition-name-regexps
  '((LANG--function-definition-regexp . 1))
  "Regexps and capture groups for LANGNAME definition names.")

(defun LANG--definition-match-valid-p (&optional pos)
  "Return non-nil if the current definition match is outside strings/comments."
  (not (nth 8 (syntax-ppss (or pos (match-beginning 0))))))

(defun LANG--definition-position (name &optional entries limit)
  "Return current-buffer definition position for NAME using ENTRIES before LIMIT."
  (catch 'found
    (save-excursion
      (dolist (entry (or entries LANG--definition-name-regexps))
        (goto-char (point-min))
        (while (re-search-forward (car entry) limit t)
          (let ((pos (match-beginning (cdr entry))))
            (when (and pos
                       (equal (match-string-no-properties (cdr entry)) name)
                       (LANG--definition-match-valid-p pos))
              (throw 'found pos))))))
    nil))
```

Do not use for project-wide lookup or parser-level resolution.
