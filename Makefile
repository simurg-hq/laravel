.DEFAULT_GOAL := help

BASE ?= origin/main
HEAD_REF ?= HEAD
CI_TOOLS_IMAGE := $(notdir $(CURDIR))-ci-tools:local
SHELLCHECK_IMAGE := koalaman/shellcheck:v0.11.0
DOCKER_RUN := docker run --rm -v "$(CURDIR):/work" -w /work -e PR_SIZE_APPROVED -e TESTS_CHANGE_APPROVED
GITLEAKS_IMAGE := zricethezav/gitleaks:v8.30.1@sha256:c00b6bd0aeb3071cbcb79009cb16a60dd9e0a7c60e2be9ab65d25e6bc8abbb7f
# PHP base images for the supported versions. The CI matrix tests each of them;
# Pint and Larastan run on the newest.
PHP_BASE_8.3 := php:8.3.35-cli-trixie@sha256:aafe21201943a8a6e497ddfb471e2ce68ada76adede38c7d61fede8918b24319
PHP_BASE_8.4 := php:8.4.26-cli-trixie@sha256:1d2cf2b7d715b5b3aa959f0150ccbcc7b71e0181b637e443abf40a7fb56bf79a
PHP_BASE_8.5 := php:8.5.11-cli-trixie@sha256:01a109229f4465bc9ef042d9198f09a4d9da7775a825dbd8572dcdbd8756c4d3
PHP ?= 8.5
LARAVEL ?= 13
PHP_IMAGE := $(notdir $(CURDIR))-php$(PHP):local
PHP_RUN := docker run --rm -v "$(CURDIR):/app" -w /app $(PHP_IMAGE)
ARGS ?=

.PHONY: help ci-tools-image pr-size test-tampering test-ci-scripts lint-ci-scripts php-image composer-update composer \
	lint pint larastan test security composer-audit secrets

help: ## List available targets
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  %-18s %s\n", $$1, $$2}'

ci-tools-image:
	@docker build -q -t $(CI_TOOLS_IMAGE) scripts/ci >/dev/null

pr-size: ci-tools-image ## Measure this branch against BASE (default origin/main)
	$(DOCKER_RUN) --entrypoint bash $(CI_TOOLS_IMAGE) scripts/ci/pr-size.sh $(BASE) $(HEAD_REF)

test-tampering: ci-tools-image ## Fail on assertions removed or changed and skips added in tests since BASE
	$(DOCKER_RUN) --entrypoint bash $(CI_TOOLS_IMAGE) scripts/ci/test-tampering.sh $(BASE) $(HEAD_REF)

test-ci-scripts: ci-tools-image ## Run the CI script tests
	$(DOCKER_RUN) $(CI_TOOLS_IMAGE) scripts/ci/tests

lint-ci-scripts: ## Lint the CI scripts with shellcheck
	$(DOCKER_RUN) $(SHELLCHECK_IMAGE) scripts/ci/*.sh

php-image:
	@test -n "$(PHP_BASE_$(PHP))" || { echo "Unsupported PHP=$(PHP); use 8.3, 8.4 or 8.5." >&2; exit 1; }
	@docker build -q --build-arg PHP_BASE=$(PHP_BASE_$(PHP)) -t $(PHP_IMAGE) docker/php >/dev/null

# A library does not commit composer.lock: every run resolves the newest
# versions its users would get. Run the other targets with the same PHP.
composer-update: php-image ## Resolve dependencies for LARAVEL (12, 13) on PHP (8.3, 8.4, 8.5)
	$(PHP_RUN) composer update --no-interaction --no-progress --with laravel/framework:^$(LARAVEL).0

composer: php-image ## Run a Composer command: make composer ARGS="require foo/bar"
	$(PHP_RUN) composer $(ARGS)

lint: pint larastan ## Run the format check and static analysis

pint: php-image ## Check PHP formatting with Pint
	$(PHP_RUN) vendor/bin/pint --test

larastan: php-image ## Run Larastan (phpstan.neon)
	$(PHP_RUN) vendor/bin/phpstan analyse --no-progress --memory-limit=1G

test: php-image ## Run the Pest test suite (ARGS are passed to Pest)
	$(PHP_RUN) vendor/bin/pest $(ARGS)

security: composer-audit secrets ## Run all security scans

composer-audit: php-image ## Check the installed PHP dependencies for known vulnerabilities
	$(PHP_RUN) composer audit --no-interaction

secrets: ## Scan the git history for secrets with gitleaks
	$(DOCKER_RUN) $(GITLEAKS_IMAGE) git --redact --no-banner -v .
