# laravel

The Laravel SDK for Simurg. It syncs scheduled tasks as monitors and reports task runs automatically, without affecting the application.

## Local setup

Prerequisites:

- [Docker](https://docs.docker.com/get-docker/) (OrbStack or Docker Desktop)
- [Lefthook](https://lefthook.dev/) for Git hooks

All language toolchains and quality gates run in pinned Docker images, so nothing else needs to be installed on the host.

Run `lefthook install` once per clone to enable the Git hooks: format, static analysis and a secret scan on every commit. Tests run in CI on every pull request.

```sh
make composer-update    # install dependencies (PHP 8.5, Laravel 13 by default)
make lint               # format check and static analysis
make test               # test suite
make help               # all targets
```

Pass `PHP` (8.3, 8.4, 8.5) and `LARAVEL` (12, 13) to try another supported
combination, for example `make composer-update PHP=8.3 LARAVEL=12` followed by
`make test PHP=8.3`.

## License

MIT. See [LICENSE](LICENSE).
