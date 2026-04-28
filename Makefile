EMACS ?= emacs
MODE_DIR ?= examples/toy-mode
MODE ?= toy
TEST_FILE := $(MODE_DIR)/$(MODE)-mode-test.el
MODE_RUNTIME_FILES := $(sort $(filter-out $(TEST_FILE),$(wildcard $(MODE_DIR)/$(MODE)-*.el)))

.PHONY: test compile polish-check clean

test:
	$(EMACS) -Q --batch -L $(MODE_DIR) \
	  -l $(TEST_FILE) \
	  -f ert-run-tests-batch-and-exit

compile:
	$(EMACS) -Q --batch -L $(MODE_DIR) \
	  -f batch-byte-compile $(MODE_RUNTIME_FILES)

polish-check:
	$(EMACS) -Q --batch -L $(MODE_DIR) \
	  --eval "(progn (require 'checkdoc) (require 'lisp-mnt) (dolist (file command-line-args-left) (with-current-buffer (find-file-noselect (expand-file-name file)) (checkdoc-current-buffer t) (lm-verify nil nil nil t))))" \
	  $(MODE_RUNTIME_FILES)

clean:
	find $(MODE_DIR) -name "*.elc" -delete
