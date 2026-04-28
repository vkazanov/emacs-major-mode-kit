;;; LANG-mode-test.el --- Tests for LANG-mode -*- lexical-binding: t; -*-

(require 'ert)
(require 'LANG-mode)

(defmacro LANG-test--with-buffer (text &rest body)
  "Create temp LANGNAME buffer with TEXT and evaluate BODY."
  (declare (indent 1))
  `(with-temp-buffer
     (insert ,text)
     (LANG-mode)
     (goto-char (point-min))
     (font-lock-ensure)
     ,@body))

(ert-deftest LANG-mode-basic-test ()
  (LANG-test--with-buffer ""
    (should (derived-mode-p 'LANG-mode))))

(provide 'LANG-mode-test)

;;; LANG-mode-test.el ends here
