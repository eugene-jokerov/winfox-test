<?php

namespace App\Test;

use ApiPlatform\Symfony\Bundle\Test\ApiTestCase;
use ApiPlatform\Symfony\Bundle\Test\Client;
use Symfony\Component\DependencyInjection\ContainerInterface;

class ApiWebTestCase extends ApiTestCase
{
    private static Client $client;

    protected static function getClient(): Client
    {
        if ( ! isset(static::$client) || ! static::$booted) {
            static::$client = static::createClient();
        }

        return static::$client;
    }

    protected static function getContainer(): ContainerInterface
    {
        return static::getClient()->getContainer();
    }
}
