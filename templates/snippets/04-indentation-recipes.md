# Indentation Recipes Snippet

Skill: `04-add-indentation.md`

Pick one recipe from the `:indentation :style` fact. Replace token regexps with
language facts and keep marker checks syntax-aware.

## Shared wrapper

```elisp
(defcustom LANG-indent-offset 4
  "Indentation offset for `LANG-mode'."
  :type 'integer
  :safe #'integerp)

(defun LANG-indent-line ()
  "Indent current LANGNAME line."
  (let ((indent (LANG-calculate-indentation))
        (pos (- (point-max) (point))))
    (indent-line-to indent)
    (when (> (- (point-max) pos) (point))
      (goto-char (- (point-max) pos)))))

(defun LANG--previous-code-line-indentation ()
  "Return indentation of the previous nonblank, non-comment LANGNAME line."
  (save-excursion
    (let ((indent 0)
          (found nil))
      (while (and (not found) (zerop (forward-line -1)))
        (back-to-indentation)
        (unless (or (looking-at-p "\\s-*$")
                    (nth 8 (syntax-ppss)))
          (setq indent (current-indentation)
                found t)))
      indent)))
```

## Zero indentation

Use for INI-like, flat, or externally formatted languages.

```elisp
(defun LANG-calculate-indentation ()
  "Return indentation column for the current LANGNAME line."
  0)
```

## Brace indentation

Use for brace-delimited blocks. Replace `[{}]` and `}` if the language uses different
tokens.

```elisp
(defun LANG--brace-depth-before (pos)
  "Return LANGNAME brace depth before POS, ignoring strings and comments."
  (save-excursion
    (let ((depth 0))
      (goto-char (point-min))
      (while (re-search-forward "[{}]" pos t)
        (let ((brace (char-after (match-beginning 0)))
              (brace-pos (match-beginning 0)))
          (unless (nth 8 (syntax-ppss brace-pos))
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

## Continuation indentation

Use for SQL-like statements, argument lists, or other line continuations where a
previous significant line opens or continues a statement.

```elisp
(defconst LANG--continuation-line-regexp "[,(]\\s-*\\(?:\\(?:--\\|#\\).*$\\)?$")
(defconst LANG--continuation-end-regexp "[])};]\\s-*\\(?:\\(?:--\\|#\\).*$\\)?$")

(defun LANG--previous-line-continues-p ()
  "Return non-nil if the previous significant line continues this LANGNAME line."
  (save-excursion
    (catch 'continues
      (while (zerop (forward-line -1))
        (back-to-indentation)
        (unless (or (looking-at-p "\\s-*$")
                    (nth 8 (syntax-ppss)))
          (end-of-line)
          (throw 'continues
                 (save-excursion
                   (beginning-of-line)
                   (and (re-search-forward LANG--continuation-line-regexp
                                           (line-end-position) t)
                        (not (nth 8 (syntax-ppss (match-beginning 0)))))))))
      nil)))

(defun LANG--line-ends-continuation-p ()
  "Return non-nil if this LANGNAME line starts with a continuation terminator."
  (save-excursion
    (back-to-indentation)
    (and (looking-at-p LANG--continuation-end-regexp)
         (not (nth 8 (syntax-ppss))))))

(defun LANG-calculate-indentation ()
  "Return indentation column for the current LANGNAME line."
  (let ((base (LANG--previous-code-line-indentation)))
    (cond
     ((LANG--line-ends-continuation-p) (max 0 (- base LANG-indent-offset)))
     ((LANG--previous-line-continues-p) (+ base LANG-indent-offset))
     (t base))))
```

## Indentation-sensitive

Use for Python-like languages where indentation is syntax. Preserve existing nonblank
line indentation unless exact block opener and dedent facts are known.

```elisp
(defun LANG-calculate-indentation ()
  "Return indentation column for the current LANGNAME line."
  (save-excursion
    (back-to-indentation)
    (if (not (looking-at-p "\\s-*$"))
        (current-indentation)
      (LANG--previous-code-line-indentation))))
```

If exact block opener facts are available, extend only blank/new-line indentation from
the previous significant line by one `LANG-indent-offset`; do not rewrite existing
semantic indentation during broad `indent-region` tests.

## Choice-depth indentation

Use for Ink-like languages where leading choice markers determine nesting depth.
Replace `[*+-]+` with the documented marker syntax.

```elisp
(defun LANG--choice-depth-at-line ()
  "Return leading choice depth at the current LANGNAME line, or nil."
  (save-excursion
    (back-to-indentation)
    (and (looking-at "\\([*+-]+\\)\\s-+")
         (not (nth 8 (syntax-ppss)))
         (length (match-string 1)))))

(defun LANG-calculate-indentation ()
  "Return indentation column for the current LANGNAME line."
  (save-excursion
    (back-to-indentation)
    (let ((depth (LANG--choice-depth-at-line)))
      (cond
       (depth (* LANG-indent-offset (max 0 (1- depth))))
       ((save-excursion
          (and (zerop (forward-line -1))
               (setq depth (LANG--choice-depth-at-line))))
        (* LANG-indent-offset depth))
       (t (LANG--previous-code-line-indentation))))))
```

Test with `indent-region` on a complete fixture and include marker-like tokens inside
strings or comments for marker-based styles.
