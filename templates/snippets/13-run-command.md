# Run Command Snippet

Skill: `13-add-run-command.md`

Use when a documented run/play command exists.

```elisp
(defun LANG-run-command (&optional file)
  "Return the LANGNAME run command for FILE."
  (let ((target (or file buffer-file-name)))
    (unless target
      (user-error "LANGNAME buffer is not visiting a file"))
    (unless (executable-find LANG-run-tool-command)
      (user-error "Cannot find LANGNAME run command: %s" LANG-run-tool-command))
    (mapconcat #'shell-quote-argument
               (append (list LANG-run-tool-command) LANG-run-tool-args (list target))
               " ")))

(defun LANG-run ()
  "Run the current LANGNAME file."
  (interactive)
  (compilation-start
   (LANG-run-command)
   'LANG-compilation-mode
   (lambda (_mode-name) "*LANGNAME Run*")))
```

Mode keymap:

```elisp
(define-key map (kbd "C-c C-r") #'LANG-run)
```

Do not add a command or keybinding when run command details are unknown.
