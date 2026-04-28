# Xref Snippet

Skill: `10-add-xref.md`

Use for current-buffer definition lookup.

```elisp
(defun LANG-xref-backend ()
  "Return the xref backend symbol for LANGNAME."
  'LANG)

(defun LANG--identifier-at-point ()
  "Return the LANGNAME identifier at point."
  (unless (nth 8 (syntax-ppss))
    (thing-at-point 'symbol t)))

(defun LANG--xref-location-at (name pos)
  "Return an xref item for NAME at POS in the current buffer."
  (save-excursion
    (goto-char pos)
    (xref-make
     name
     (xref-make-file-location
      (or buffer-file-name (buffer-name))
      (line-number-at-pos)
      (current-column)))))

(cl-defmethod xref-backend-identifier-at-point ((_backend (eql LANG)))
  (LANG--identifier-at-point))

(cl-defmethod xref-backend-definitions ((_backend (eql LANG)) identifier)
  (when-let* ((pos (LANG--definition-position identifier)))
    (list (LANG--xref-location-at identifier pos))))
```

Mode setup:

```elisp
(add-hook 'xref-backend-functions #'LANG-xref-backend nil t)
```
