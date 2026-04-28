EMACS ?= emacs
MODE_DIR ?= examples/toy-mode
MODE ?= toy
MODE_FILE := $(MODE_DIR)/$(MODE)-mode.el
TEST_FILE := $(MODE_DIR)/$(MODE)-mode-test.el

.PHONY: test compile clean

test:
	$(EMACS) -Q --batch -L $(MODE_DIR) \
	  -l $(TEST_FILE) \
	  -f ert-run-tests-batch-and-exit

compile:
	$(EMACS) -Q --batch -L $(MODE_DIR) \
	  -f batch-byte-compile $(MODE_FILE)

clean:
	find . -name "*.elc" -delete
