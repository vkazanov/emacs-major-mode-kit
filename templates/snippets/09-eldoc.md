# Eldoc Snippet

Skill: `09-add-eldoc.md`

Use for static facts-derived documentation only.

```elisp
(defconst LANG--eldoc
  '(("keyword" . "keyword ARG: short documentation."))
  "Static Eldoc facts for LANGNAME.")

(defun LANG-eldoc-function (callback &rest _ignored)
  "Return static LANGNAME documentation at point using CALLBACK."
  (unless (nth 8 (syntax-ppss))
    (when-let* ((symbol (thing-at-point 'symbol t))
                (doc (cdr (assoc symbol LANG--eldoc))))
      (funcall callback doc :thing symbol)
      doc)))
```

Mode setup:

```elisp
(add-hook 'eldoc-documentation-functions #'LANG-eldoc-function nil t)
```

Do not start processes or fetch documentation.
