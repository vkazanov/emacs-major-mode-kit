;;; LANG-facts.el --- Language facts for LANGNAME -*- lexical-binding: t; -*-

(defconst LANG-facts
  '(:language "LANGNAME"
    :extensions ("EXT")

    :comments
    (:line nil
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

    :tools
    (:compiler nil
     :formatter nil
     :repl nil))
  "Language facts for LANGNAME.")

(provide 'LANG-facts)

;;; LANG-facts.el ends here
