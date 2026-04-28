;;; toy-mode.el --- Major mode for Toy -*- lexical-binding: t; -*-

;; Keywords: languages
;; Package-Requires: ((emacs "29.1"))

;;; Commentary:

;; Major mode for editing Toy files.

;;; Code:

(require 'cl-lib)
(require 'imenu)
(require 'newcomment)

(defgroup toy nil
  "Major mode for Toy."
  :group 'languages)

;;;; Customization

(defcustom toy-indent-offset 4
  "Indentation offset for `toy-mode'."
  :type 'integer
  :safe #'integerp)

;;;; Keymap

(defvar toy-mode-map
  (let ((map (make-sparse-keymap)))
    map)
  "Keymap for `toy-mode'.")

;;;; Syntax

(defvar toy-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?/ ". 124b" table)
    (modify-syntax-entry ?* ". 23" table)
    (modify-syntax-entry ?\n "> b" table)
    (modify-syntax-entry ?\" "\"" table)
    (modify-syntax-entry ?\\ "\\" table)
    table)
  "Syntax table for `toy-mode'.")

;;;; Language data

(defconst toy-facts
  '(:language "Toy"
    :extensions ("toy")

    :comments
    (:line "//"
     :block-start "/*"
     :block-end "*/")

    :strings
    (:delimiters ("\"")
     :escape "\\")

    :keywords ("else" "func" "if" "let" "return")
    :builtins ("print")

    :definitions
    (:function "\\_<func\\_>\\s-+\\([[:alpha:]_][[:alnum:]_]*\\)"
     :type nil
     :variable "\\_<let\\_>\\s-+\\([[:alpha:]_][[:alnum:]_]*\\)")

    :indentation
    (:style braces
     :offset 4)

    :tools
    (:compiler nil
     :formatter nil
     :repl nil))
  "Language facts for Toy.")

(defconst toy--comments
  (plist-get toy-facts :comments)
  "Comment facts for Toy.")

(defconst toy--keywords
  (plist-get toy-facts :keywords)
  "Keyword facts for Toy.")

(defconst toy--builtins
  (plist-get toy-facts :builtins)
  "Builtin facts for Toy.")

(defconst toy--definitions
  (plist-get toy-facts :definitions)
  "Definition facts for Toy.")

(defconst toy--function-definition-regexp
  (plist-get toy--definitions :function)
  "Regexp matching Toy function definitions.")

(defconst toy--variable-definition-regexp
  (plist-get toy--definitions :variable)
  "Regexp matching Toy variable definitions.")

;;;; Font lock

(defconst toy-font-lock-keywords
  `((,(regexp-opt toy--keywords 'symbols) . font-lock-keyword-face)
    (,(regexp-opt toy--builtins 'symbols) . font-lock-builtin-face)
    (,toy--function-definition-regexp 1 font-lock-function-name-face)
    (,toy--variable-definition-regexp 1 font-lock-variable-name-face))
  "Font-lock keywords for `toy-mode'.")

;;;; Indentation

(defun toy--brace-depth-before (pos)
  "Return Toy brace depth before POS, ignoring strings and comments."
  (save-excursion
    (let ((depth 0))
      (goto-char (point-min))
      (while (re-search-forward "[{}]" pos t)
        (let ((brace (char-after (match-beginning 0)))
              (brace-pos (match-beginning 0)))
          (unless (save-excursion
                    (nth 8 (syntax-ppss brace-pos)))
            (setq depth
                  (if (eq brace ?{)
                      (1+ depth)
                    (max 0 (1- depth)))))))
      depth)))

(defun toy--line-closes-block-p ()
  "Return non-nil if the current Toy line begins with a closing brace."
  (save-excursion
    (back-to-indentation)
    (and (looking-at-p "}")
         (not (nth 8 (syntax-ppss))))))

(defun toy-calculate-indentation ()
  "Return indentation column for the current Toy line."
  (let ((depth (toy--brace-depth-before (line-beginning-position))))
    (* toy-indent-offset
       (if (toy--line-closes-block-p)
           (max 0 (1- depth))
         depth))))

(defun toy-indent-line ()
  "Indent current line as Toy code."
  (interactive)
  (let ((pos (- (point-max) (point))))
    (indent-line-to (toy-calculate-indentation))
    (when (> (- (point-max) pos) (point))
      (goto-char (- (point-max) pos)))))

;;;; Imenu

(defconst toy-imenu-generic-expression
  `((nil ,toy--function-definition-regexp 1))
  "Imenu expressions for `toy-mode'.")

;;;; Mode definition

;;;###autoload
(define-derived-mode toy-mode prog-mode "Toy"
  "Major mode for editing Toy files."
  :syntax-table toy-mode-syntax-table
  (setq-local font-lock-defaults '(toy-font-lock-keywords))
  (setq-local indent-line-function #'toy-indent-line)
  (setq-local indent-tabs-mode nil)
  (setq-local comment-start (concat (plist-get toy--comments :line) " "))
  (setq-local comment-end "")
  (setq-local comment-start-skip "\\(?://+\\|/\\*+\\)\\s *")
  (setq-local comment-use-syntax t)
  (setq-local imenu-generic-expression toy-imenu-generic-expression))

;;;; File associations

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.toy\\'" . toy-mode))

(provide 'toy-mode)

;;; toy-mode.el ends here
