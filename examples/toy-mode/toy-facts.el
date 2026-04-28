;;; toy-facts.el --- Language facts for Toy -*- lexical-binding: t; -*-

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

(provide 'toy-facts)

;;; toy-facts.el ends here
