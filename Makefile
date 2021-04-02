.DEFAULT_GOAL := help
.PHONY: help
# Variables
SHELL := /bin/bash -e

## help: This help
help: $(MAKEFILE)
	@echo
	@echo " Choose a command run:"
	@echo
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-40s\033[0m %s\n", $$1, $$2}'
	@echo

fetch-gist: ## Fetch gist content from list and save into selected directory
	@(PS3="Input your folder choice to store or cltr-C to quit: "; select DIR in `find . -maxdepth 1 -not -name ".*" -type d | awk -F'./' '{ print $$2 }'`; do (gh gist list; PS3="Input your gist choice to view or cltr-C to quit: "; select opt in `gh gist list | awk '{ print $$1 }'`; do FILE=`gh gist view --files $${opt}`; gh gist view -r $${opt} -f $${FILE} > $${DIR}/$${FILE}; break; done); break; done)
