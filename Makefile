.DEFAULT_GOAL := help

# PHP base images for the supported versions.
PHP_BASE_8.3 := php:8.3.35-cli-trixie@sha256:aafe21201943a8a6e497ddfb471e2ce68ada76adede38c7d61fede8918b24319
PHP_BASE_8.4 := php:8.4.26-cli-trixie@sha256:1d2cf2b7d715b5b3aa959f0150ccbcc7b71e0181b637e443abf40a7fb56bf79a
PHP_BASE_8.5 := php:8.5.11-cli-trixie@sha256:01a109229f4465bc9ef042d9198f09a4d9da7775a825dbd8572dcdbd8756c4d3
PHP ?= 8.5
LARAVEL ?= 13
PHP_IMAGE := $(notdir $(CURDIR))-php$(PHP):local
PHP_RUN := docker run --rm -v "$(CURDIR):/app" -w /app $(PHP_IMAGE)
ARGS ?=

.PHONY: help php-image composer-update composer test

help: ## List available targets
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  %-18s %s\n", $$1, $$2}'

php-image:
	@test -n "$(PHP_BASE_$(PHP))" || { echo "Unsupported PHP=$(PHP); use 8.3, 8.4 or 8.5." >&2; exit 1; }
	@docker build -q --build-arg PHP_BASE=$(PHP_BASE_$(PHP)) -t $(PHP_IMAGE) docker/php >/dev/null

# A library does not commit composer.lock: every run resolves the newest
# versions its users would get. Run the other targets with the same PHP.
composer-update: php-image ## Resolve dependencies for LARAVEL (12, 13) on PHP (8.3, 8.4, 8.5)
	$(PHP_RUN) composer update --no-interaction --no-progress --with laravel/framework:^$(LARAVEL).0

composer: php-image ## Run a Composer command: make composer ARGS="require foo/bar"
	$(PHP_RUN) composer $(ARGS)

test: php-image ## Run the Pest test suite (ARGS are passed to Pest)
	$(PHP_RUN) vendor/bin/pest --configuration phpunit.xml.dist $(ARGS)
