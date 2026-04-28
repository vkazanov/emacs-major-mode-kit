;;; toy-mode-test.el --- Tests for toy-mode -*- lexical-binding: t; -*-

(require 'ert)
(require 'imenu)
(require 'toy-mode)

(defmacro toy-test--with-buffer (text &rest body)
  "Create temp Toy buffer with TEXT and evaluate BODY."
  (declare (indent 1))
  `(with-temp-buffer
     (insert ,text)
     (toy-mode)
     (goto-char (point-min))
     (font-lock-ensure)
     ,@body))

(defun toy-test--face-matches-p (face expected)
  "Return non-nil when FACE includes EXPECTED."
  (or (eq face expected)
      (and (listp face)
           (memq expected face))))

(defun toy-test--face-at (regexp &optional group)
  "Return face at REGEXP match GROUP in the current buffer."
  (goto-char (point-min))
  (should (re-search-forward regexp nil t))
  (get-text-property (match-beginning (or group 0)) 'face))

(ert-deftest toy-mode-basic-test ()
  (toy-test--with-buffer ""
    (should (derived-mode-p 'toy-mode))))

(ert-deftest toy-mode-line-comment-syntax-test ()
  (toy-test--with-buffer "func main() {\n  // comment\n}\n"
    (search-forward "comment")
    (should (nth 4 (syntax-ppss)))))

(ert-deftest toy-mode-block-comment-syntax-test ()
  (toy-test--with-buffer "func main() {\n  /* block comment */\n}\n"
    (search-forward "block")
    (should (nth 4 (syntax-ppss)))))

(ert-deftest toy-mode-string-syntax-test ()
  (toy-test--with-buffer "func main() {\n  print(\"/* not comment */\");\n}\n"
    (search-forward "not comment")
    (should (nth 3 (syntax-ppss)))
    (should-not (nth 4 (syntax-ppss)))))

(ert-deftest toy-mode-keyword-face-test ()
  (toy-test--with-buffer "func main() {\n  if ready {\n    return;\n  }\n}\n"
    (should (toy-test--face-matches-p
             (toy-test--face-at "\\_<if\\_>")
             'font-lock-keyword-face))))

(ert-deftest toy-mode-builtin-face-test ()
  (toy-test--with-buffer "func main() {\n  print(\"ok\");\n}\n"
    (should (toy-test--face-matches-p
             (toy-test--face-at "\\_<print\\_>")
             'font-lock-builtin-face))))

(ert-deftest toy-mode-function-name-face-test ()
  (toy-test--with-buffer "func main() {\n  return;\n}\n"
    (should (toy-test--face-matches-p
             (toy-test--face-at "\\_<func\\_>\\s-+\\([[:alpha:]_][[:alnum:]_]*\\)" 1)
             'font-lock-function-name-face))))

(ert-deftest toy-mode-variable-name-face-test ()
  (toy-test--with-buffer "func main() {\n  let value = 1;\n}\n"
    (should (toy-test--face-matches-p
             (toy-test--face-at "\\_<let\\_>\\s-+\\([[:alpha:]_][[:alnum:]_]*\\)" 1)
             'font-lock-variable-name-face))))

(ert-deftest toy-mode-indentation-test ()
  (toy-test--with-buffer
      "func main() {\nlet value = \"}\";\nif value {\nprint(value);\n}\n// { ignored\n/* } ignored */\n}\n"
    (indent-region (point-min) (point-max))
    (should
     (equal
      (buffer-string)
      "func main() {\n    let value = \"}\";\n    if value {\n        print(value);\n    }\n    // { ignored\n    /* } ignored */\n}\n"))))

(ert-deftest toy-mode-imenu-test ()
  (toy-test--with-buffer "func main() {\n}\n\nfunc helper() {\n}\n"
    (let ((index (imenu--make-index-alist)))
      (should (assoc "main" index))
      (should (assoc "helper" index)))))

(provide 'toy-mode-test)

;;; toy-mode-test.el ends here
