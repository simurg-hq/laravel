# AGENTS.md

Instructions for coding agents and humans working in this repository.

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
| `scripts/ci/` | CI helper scripts and their tests. |

Some of these paths are created by later tasks; keep to this layout when you
add them.

## Naming

- PHP follows PSR-12 as enforced by Pint. Classes `PascalCase`, methods and variables `camelCase`, config keys `snake_case`.
- Names describe behavior: `ReportTaskFinished`, not `TaskHelper`.
- Artisan commands use the package prefix, for example `simurg:sync`.

## Rules

- Supported versions: PHP 8.3+, Laravel 12 and 13. Do not use features unavailable in the oldest supported version.
- One task, one branch, one pull request against `main`. Keep the diff outside tests and generated files under 400 lines; if it will not fit, stop and ask for the task to be split.
- Write the failing test first. Every acceptance criterion maps to at least one test.
- Implement only what the task asks for.
- Never call `env()` outside `config/`. Never commit `dd`, `dump` or `ray`.
- Never lower a threshold, disable or skip a check, delete or weaken a test, or add an ignore comment, suppression or baseline to make a gate pass. Such a change needs its own pull request approved by a human.
- Do not change `.github/`, `AGENTS.md`, `CLAUDE.md`, `phpstan.neon` or test thresholds unless the task is explicitly about them.
- Never hardcode the product name in user-facing text; use `Product::NAME`.
- Never create or commit secrets, tokens or real credentials.
- Code, comments, commit messages and documents are in English.
- Commit messages use a type prefix: `feat`, `fix`, `test`, `refactor`, `docs`, `ci`, `chore`.

## Quality gates

Every gate runs in Docker through `make`; nothing but Docker and Lefthook is
needed on the host. Run the gates before pushing and show their output as
evidence. "It should work" is not evidence.

```sh
make help               # list all targets
make composer-update    # resolve dependencies (PHP=8.5 LARAVEL=13 by default)
make lint               # Pint format check and Larastan at level max
make test               # Pest on Orchestra Testbench
make security           # composer audit and gitleaks
make lint-ci-scripts    # shellcheck for scripts/ci
make test-ci-scripts    # bats tests for scripts/ci
make pr-size            # measure this branch against origin/main
make test-tampering     # assertions removed or changed and skips added in tests since origin/main
```

There is no committed `composer.lock`: like any library, each run resolves
the newest versions users would get. CI tests every supported PHP and Laravel
pair; reproduce one locally with the same `PHP` for both commands:

```sh
make composer-update PHP=8.3 LARAVEL=12 && make test PHP=8.3
```

A task that adds a gate also adds its `make` target and lists it here.

## When you are stuck

1. If the same gate fails three times, do not weaken the test or the gate.
2. Hand the task to the next implementer tier.
3. If the top tier also fails three times on the same gate, stop and write a blocker note: which gate failed, the exact error, what was tried and why it did not work.

## Definition of done

The checklist in `.github/pull_request_template.md` must be complete before a
pull request is merged.
