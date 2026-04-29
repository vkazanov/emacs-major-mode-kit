EMACS ?= emacs
MODE_DIR ?= examples/toy-mode
MODE ?= toy
TEST_FILES := $(sort $(wildcard $(MODE_DIR)/*-test.el))
TEST_LOAD_ARGS := $(foreach file,$(TEST_FILES),-l $(file))
MODE_RUNTIME_FILES := $(sort $(filter-out $(TEST_FILES),$(wildcard $(MODE_DIR)/$(MODE)-*.el)))
LANGUAGE_OVERVIEW := $(MODE_DIR)/reference/language-overview.md

.PHONY: test compile overview-check polish-check validate validate-polished clean

test:
	$(EMACS) -Q --batch -L $(MODE_DIR) \
	  $(TEST_LOAD_ARGS) \
	  -f ert-run-tests-batch-and-exit

compile:
	$(EMACS) -Q --batch -L $(MODE_DIR) \
	  -f batch-byte-compile $(MODE_RUNTIME_FILES)

overview-check:
	@if [ ! -e "$(LANGUAGE_OVERVIEW)" ]; then \
	  echo "Missing language overview: $(LANGUAGE_OVERVIEW)"; \
	  exit 1; \
	fi

polish-check:
	$(EMACS) -Q --batch -L $(MODE_DIR) \
	  --eval "(progn (require 'checkdoc) (require 'lisp-mnt) (dolist (file command-line-args-left) (with-current-buffer (find-file-noselect (expand-file-name file)) (checkdoc-current-buffer t) (lm-verify nil nil nil t))))" \
	  $(MODE_RUNTIME_FILES)

validate:
	@status=0; \
	$(MAKE) overview-check || status=$$?; \
	if [ $$status -eq 0 ]; then $(MAKE) test || status=$$?; fi; \
	if [ $$status -eq 0 ]; then $(MAKE) compile || status=$$?; fi; \
	$(MAKE) clean || true; \
	exit $$status

validate-polished:
	@status=0; \
	$(MAKE) overview-check || status=$$?; \
	if [ $$status -eq 0 ]; then $(MAKE) test || status=$$?; fi; \
	if [ $$status -eq 0 ]; then $(MAKE) compile || status=$$?; fi; \
	if [ $$status -eq 0 ]; then $(MAKE) polish-check || status=$$?; fi; \
	$(MAKE) clean || true; \
	exit $$status

clean:
	find $(MODE_DIR) -name "*.elc" -delete
