;;; LANG-facts.el --- Language facts for LANGNAME -*- lexical-binding: t; -*-

(defconst LANG-facts
  '(:language "LANGNAME"
    :extensions ("EXT")

    :comments
    (:line nil
     :line-alternates nil
     :block-start nil
     :block-end nil)

    :strings
    (:delimiters nil
     :escape nil)

    :keywords nil
    :builtins nil

    :definitions
    (:function nil
     :type nil
     :variable nil)

    :indentation
    (:style nil
     :offset 4)

    :outline
    (:regexp nil
     :level nil)

    :defun
    (:beginning nil
     :end nil)

    :completion
    (:keywords t
     :builtins t
     :symbols nil)

    :eldoc
    (:keywords nil
     :builtins nil)

    :xref
    (:definitions nil)

    :diagnostics
    (:command nil
     :output nil)

    :compilation
    (:command nil
     :error-regexp nil)

    :run
    (:command nil
     :args nil
     :use-compile nil)

    :formatter
    (:command nil
     :args nil
     :stdin nil
     :scope nil)

    :syntax-propertize
    (:rules nil)

    :treesit
    (:language nil
     :font-lock nil
     :indent nil
     :imenu nil
     :defun nil)

    :tools
    (:compiler nil
     :diagnostic nil
     :formatter nil
     :repl nil))
  "Language facts for LANGNAME.")

(provide 'LANG-facts)

;;; LANG-facts.el ends here
