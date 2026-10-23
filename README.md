# laravel

The Laravel SDK for Simurg. It syncs scheduled tasks as monitors and reports task runs automatically, without affecting the application.

## Local setup

Prerequisite: [Docker](https://docs.docker.com/get-docker/) (OrbStack or Docker Desktop). The toolchain runs in a pinned Docker image.

```sh
make composer-update    # install dependencies (PHP 8.5, Laravel 13 by default)
make test               # test suite
make help               # all targets
```

Pass `PHP` (8.3, 8.4, 8.5) and `LARAVEL` (12, 13) to try another supported
combination, for example `make composer-update PHP=8.3 LARAVEL=12` followed by
`make test PHP=8.3`.

## License

MIT. See [LICENSE](LICENSE).
