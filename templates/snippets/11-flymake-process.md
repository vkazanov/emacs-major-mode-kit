# Flymake Process Snippet

Skill: `11-add-flymake.md`

Use when a diagnostic command and representative output format are known. Missing local
tool installation should not be a load-time error.

```elisp
(defvar-local LANG--flymake-process nil
  "Current LANGNAME Flymake process.")

(defun LANG-flymake-backend (report-fn &rest _args)
  "Run the LANGNAME diagnostic tool and report diagnostics through REPORT-FN."
  (if (not (executable-find LANG-diagnostic-command))
      (funcall report-fn nil)
    (when (process-live-p LANG--flymake-process)
      (kill-process LANG--flymake-process))
    (let* ((source (current-buffer))
           (temp-file (make-temp-file "LANG-flymake-" nil ".EXT"))
           (output-buffer (generate-new-buffer " *LANG-flymake*")))
      (write-region nil nil temp-file nil 0)
      (setq LANG--flymake-process
            (make-process
             :name "LANG-flymake"
             :buffer output-buffer
             :command (list LANG-diagnostic-command temp-file)
             :noquery t
             :sentinel
             (lambda (process _event)
               (when (memq (process-status process) '(exit signal))
                 (unwind-protect
                     (when (buffer-live-p source)
                       (with-current-buffer source
                         (when (eq process LANG--flymake-process)
                           (setq LANG--flymake-process nil)
                           (funcall report-fn
                                    (LANG--flymake-diagnostics-for-buffer
                                     source
                                     (if (buffer-live-p output-buffer)
                                         (with-current-buffer output-buffer
                                           (buffer-string))
                                       ""))))))
                   (when (file-exists-p temp-file) (delete-file temp-file))
                   (when (buffer-live-p output-buffer)
                     (kill-buffer output-buffer))))))))))
```

Mode setup:

```elisp
(add-hook 'flymake-diagnostic-functions #'LANG-flymake-backend nil t)
```

Tests should stub `executable-find` and `make-process`.
