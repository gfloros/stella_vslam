# Default shell is sh, set to bash
SHELL := /bin/bash
# Run as single shell session
.ONESHELL:
# Use bash strict mode
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
.SHELLFLAGS := -eu -o pipefail -c
# Delete target if make rule fails
# https://innolitics.com/articles/make-delete-on-error/
.DELETE_ON_ERROR:

# Warn if using undefined variables
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

CURRENT_DIR := $(shell pwd)

.DEFAULT_GOAL := help

.PHONY: help install local bash env

# Self documenting makefile
# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
# To add documentation for a specific target
# add a comment starting with ## after the rule name
help:
	@echo "stella_vslam"
	@grep -E '^[a-zA-Z_0-9%-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

local: ## Build the docker container
	docker build -t stella_vslam -f Dockerfile.desktop .

bash: ## Run the docker container
	docker run --rm -it --name stella_vslam stella_vslam