<?php

namespace Simurg\Laravel\Tests;

use Orchestra\Testbench\TestCase as Orchestra;
use Simurg\Laravel\SimurgServiceProvider;

abstract class TestCase extends Orchestra
{
    protected function getPackageProviders($app): array
    {
        return [SimurgServiceProvider::class];
    }
}
