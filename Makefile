# Makefile for prompt-command-wrap

# See https://stackoverflow.com/a/73509979/237059
absdir := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

SHELL=/bin/bash

Version := $(shell cat version)


.PHONY: help
help:
	@$(MAKE) -s --print-data-base --question no-such-target 2>/dev/null | \
	grep -v  -e '^Makefile' -e '^help' | \
	awk '/^[^.%][-A-Za-z0-9_]*:/ \
			{ print substr($$1, 1, length($$1)-1) }' | \
	sort | \
	pr --omit-pagination --width=100 --columns=3


tmp/prompt-command-wrap.bashrc: prompt-command-wrap.bashrc.template version
	@command sed -e 's/<PcwrapVer>/$(Version)/g' $< > $@

.PHONY: build

$(HOME)/bin/prompt-command-wrap.bashrc: tmp/prompt-command-wrap.bashrc
	@cp tmp/prompt-command-wrap.bashrc ~/bin/
	@echo "WARNING: temporary ~/bin/prompt-command-wrap.bashrc.  This step should be removed when shellkits that set PROMPT_COMMAND are converted to __pcwrap_run()" >&2

build: tmp/prompt-command-wrap.bashrc ~/bin/prompt-command-wrap.bashrc

