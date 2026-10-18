<?php

use Simurg\Laravel\SimurgServiceProvider;

it('boots the service provider in a Laravel application', function () {
    expect(app()->providerIsLoaded(SimurgServiceProvider::class))->toBeBool();
});
