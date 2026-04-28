# Definition Scanning Snippet

Skills: `07-add-beginning-end-of-defun.md`, `10-add-xref.md`

Use when definition matches are regular enough for current-buffer regexps.

## Shared definition facts

```elisp
(defconst LANG--definition-start-regexp LANG--function-definition-regexp
  "Regexp matching the start of a LANGNAME top-level definition.")

(defconst LANG--definition-name-regexps
  '((LANG--function-definition-regexp . 1))
  "Regexps and capture groups for LANGNAME definition names.")

(defun LANG--definition-match-valid-p (&optional pos)
  "Return non-nil if the current definition match is outside strings/comments."
  (not (nth 8 (syntax-ppss (or pos (match-beginning 0))))))
```

## Defun navigation

Use for skill `07`. The beginning function follows the Emacs contract: nil ARG acts
like 1, positive ARG moves backward, and negative ARG moves forward.

```elisp
(defun LANG--search-definition-start (direction &optional limit)
  "Search for a LANGNAME definition start in DIRECTION before LIMIT.
DIRECTION is either `backward' or `forward'.  Return non-nil when found."
  (let ((search (if (eq direction 'backward)
                    #'re-search-backward
                  #'re-search-forward))
        found)
    (when (and (eq direction 'forward)
               (looking-at-p LANG--definition-start-regexp))
      (forward-line 1))
    (while (and (not found)
                (funcall search LANG--definition-start-regexp limit t))
      (when (LANG--definition-match-valid-p)
        (setq found (match-beginning 0))))
    (when found
      (goto-char found)
      (beginning-of-line)
      t)))

(defun LANG-beginning-of-defun (&optional arg)
  "Move to the beginning of a LANGNAME definition.
ARG follows the `beginning-of-defun' convention."
  (let* ((arg (or arg 1))
         (direction (if (< arg 0) 'forward 'backward))
         (count (abs arg))
         found)
    (while (and (> count 0)
                (setq found (LANG--search-definition-start direction)))
      (setq count (1- count)))
    (and (zerop count) found)))

(defun LANG-end-of-defun ()
  "Move to the end of the current LANGNAME definition."
  (unless (LANG--search-definition-start 'forward)
    (goto-char (point-max)))
  t)
```

Set `end-of-defun-function` only when ending at the next definition start or buffer end
is good enough for the language.

## Xref lookup

Use for skill `10`.

```elisp
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
