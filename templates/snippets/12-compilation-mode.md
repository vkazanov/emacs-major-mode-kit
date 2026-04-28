# Compilation Mode Snippet

Skill: `12-add-compilation-mode.md`

Use when a compiler/checker output format is documented.

```elisp
(defconst LANG-compilation-error-regexp
  "^\\(.+\\):\\([0-9]+\\):\\([0-9]+\\): \\(error\\|warning\\): \\(.+\\)$"
  "Regexp matching LANGNAME tool output.")

(defconst LANG-compilation-error-regexp-alist
  `((,LANG-compilation-error-regexp 1 2 3 2))
  "Compilation regexps for LANGNAME tool output.")

(define-compilation-mode LANG-compilation-mode "LANGNAME Compilation"
  "Compilation mode for LANGNAME tool output."
  (setq-local compilation-error-regexp-alist
              LANG-compilation-error-regexp-alist))

(defun LANG-compile-command (&optional file)
  "Return the default LANGNAME compile command for FILE."
  (when-let* ((target (or file buffer-file-name)))
    (mapconcat #'shell-quote-argument
               (list LANG-compiler-command target)
               " ")))
```

Set `compile-command` buffer-locally only when a current file exists.
