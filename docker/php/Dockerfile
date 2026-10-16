# Toolchain for local commands and CI: PHP with Composer for Pint, Larastan
# and Pest. The Makefile passes the PHP base image (tag and digest) so the
# same file builds every PHP version in the test matrix.
ARG PHP_BASE
FROM composer:2.10.3@sha256:af98f42dfff7c68ba8d53c2164fd9fde1087b7d449514baa38c418b1f6bc4bac AS composer

FROM ${PHP_BASE}

RUN apt-get update \
    && apt-get install -y --no-install-recommends git unzip \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

ENV COMPOSER_HOME=/tmp/composer
WORKDIR /app
