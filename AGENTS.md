# AGENTS.md

Project knowledge for anyone working in this repository.

## Purpose

`laravel` is the Laravel SDK, distributed as a Composer package. It syncs the
application's scheduled tasks as monitors, reports task runs automatically
through the public ping protocol, and lets tasks report metrics.

The one rule that overrides everything else: the SDK never affects the host
application. Pings use short timeouts, failures are logged quietly and never
thrown into application code.

This repository is public and MIT licensed. It must stay self-contained: do
not reference private repositories or internal documents.

## Repository layout

| Path | Contents |
| --- | --- |
| `src/` | Package source, namespace `Simurg\Laravel`. |
| `src/Product.php` | The single product name constant. |
| `config/` | Publishable package configuration. |
| `tests/` | Pest tests running on Orchestra Testbench. |

## Naming

- PHP follows PSR-12. Classes `PascalCase`, methods and variables `camelCase`, config keys `snake_case`.
- Names describe behavior: `ReportTaskFinished`, not `TaskHelper`.
- Artisan commands use the package prefix, for example `simurg:sync`.

## Rules

- Supported versions: PHP 8.3+, Laravel 12 and 13. Do not use features unavailable in the oldest supported version.
- Never call `env()` outside `config/`. Never commit `dd`, `dump` or `ray`.
- Never hardcode the product name in user-facing text; use `Product::NAME`.
- Never create or commit secrets, tokens or real credentials.
- Code, comments, commit messages and documents are in English.
