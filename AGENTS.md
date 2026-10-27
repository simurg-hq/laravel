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

## Implementation

- Meet every need the task states; check them one by one before calling the work done.
- Follow the best practices of the language and its tools. Keep the code DRY and the design SOLID, without layers that only restate configuration.
- Weigh performance and security in every change.
- Where Laravel has a way to do something, use it before writing your own.
- Use the most modern Laravel and PHP techniques that the oldest supported versions allow.

## Code Review

Use this checklist for every code review: a review by an agent, by a sub-agent, or by a person. Review only the changes in scope (the session, the task, or the pull request), not the whole branch.

### Checklist

1. **Requirement**: The change does what the task or the issue asks. Compare each acceptance item with the code. Report a missing item, and report a change that the task does not ask for (refactor, rename, reformat).
2. **Behavior change**: Find each change to existing behavior that a client or an operator can see: API response shape, status code, validation message, command output, log message and log context, queue payload, cache key. Each such change must be intentional and named in the task or in the pull request description.
3. **Laravel way**: When Laravel or an installed package has a built-in way to do a thing, the code uses it: FormRequest, policy, API resource, scope, cast, validation `Rule`, collection method, `Http` client, and the like. Hand-written code that repeats framework behavior is a finding.
4. **Current techniques**: The code uses the current API of the installed version (`composer show`, `vendor/`). Report a deprecated API, and report an API from a newer version that is not installed.
5. **Best practice, DRY, SOLID**: Each class has one responsibility. Controllers stay thin, and use-case logic is in Action classes. Duplicated logic is a finding when it is a rule that must change in all copies together. Two short lines that look the same are not a finding.
6. **Unnecessary complexity**: The code is the simplest code that meets the requirement. A new abstraction, interface, config option, or generalization with one caller and no requirement is a finding. When review rounds find problems in the same area again and again, suggest a simpler design instead of one more patch.
7. **Security**: Each new route and action has authorization. All input is validated. Mass assignment is limited to the fillable attributes. Raw SQL uses bindings. Logs, responses, and exceptions do not contain a secret, an API key, or personal data. File uploads check type and size. Endpoints that can be abused have a rate limit.
8. **Performance**: There are no N+1 queries. Queries use an index. There is no cost that grows with the data: no full table scan, no loading of all rows into memory, no query per row in a loop. Slow work goes to a queue. Under Octane, no request state is kept in a singleton or a static property.
9. **Data and deploy safety**: A migration is safe on the production data volume (table locks, backfill time). The code works while old and new workers run together during a deploy.
10. **Test value**: Tests cover the changed behavior and its important failure paths. Each test fails when the behavior breaks: think of a small wrong change to the code and make sure that a test catches it. Expected values come from the requirement, not from a copy of the code output.
11. **Test layout**: Scenarios of the same behavior are in one test with a named dataset, or in one test with more assertions. They are not spread over separate test methods that repeat the same arrange step. Exception: model relationships have one test for each relationship.
12. **Project rules**: The change follows the other rules in this file (conventions, project, testing). Do not report what Pint already checks.

### Findings

- Each finding has `file:line`, a severity, and a concrete scenario: the input or the state, and the wrong result.
- Severity: **high** is wrong behavior, data loss, or a security problem. **medium** is a real problem with a limited effect. **low** is readability or a small improvement.
- Do not report a personal preference as a finding. "No findings" is a valid result.
