# Formatter Snippet

Skill: `14-add-format-command.md`

Use for synchronous stdin/stdout formatters. Keep the original buffer unchanged on
failure.

```elisp
(defun LANG-format-buffer ()
  "Format the current LANGNAME buffer."
  (interactive)
  (unless (executable-find LANG-formatter-command)
    (user-error "Cannot find LANGNAME formatter: %s" LANG-formatter-command))
  (let ((source (current-buffer))
        (point-pos (point)))
    (with-temp-buffer
      (let ((output (current-buffer)))
        (with-current-buffer source
          (let ((status (apply #'call-process-region
                               (point-min) (point-max)
                               LANG-formatter-command
                               nil output nil
                               LANG-formatter-args)))
            (unless (zerop status)
              (user-error "LANGNAME formatter failed with status %s" status))))
        (let ((formatted (buffer-string)))
          (with-current-buffer source
            (erase-buffer)
            (insert formatted)
            (goto-char (min point-pos (point-max)))))))))
```

Tests should stub `executable-find` and `call-process-region`.
