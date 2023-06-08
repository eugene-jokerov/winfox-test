<?php

namespace App\Tests\functional\Api;

use App\Repository\UserRepository;
use App\Test\ApiWebTestCase;

class UserTest extends ApiWebTestCase
{
    public function testCreate(): void
    {
        $testData = [
            'email'     => 'test@test.ru',
            'firstName' => 'Test',
            'lastName'  => 'Testov'
        ];
        static::getClient()->request('POST', '/api/users', [
            'json' => $testData
        ]);
        self::assertResponseStatusCodeSame(201);
        $user = static::getContainer()->get(UserRepository::class)->findOneBy(['email' => $testData['email']]);
        self::assertNotNull($user);
    }

    public function testCreateRussianEmail(): void
    {
        $testData = [
            'email'     => 'test@россия.рф',
            'firstName' => 'Test',
            'lastName'  => 'Testov'
        ];
        static::getClient()->request('POST', '/api/users', [
            'json' => $testData
        ]);
        self::assertResponseStatusCodeSame(201);
        $user = static::getContainer()->get(UserRepository::class)->findOneBy(['email' => $testData['email']]);
        self::assertNotNull($user);
    }

    public function testBadEmail(): void
    {
        $testData = [
            'email'     => 'test@sss',
            'firstName' => 'Test',
            'lastName'  => 'Testov'
        ];
        static::getClient()->request('POST', '/api/users', [
            'json' => $testData
        ]);
        self::assertResponseStatusCodeSame(422);
        $user = static::getContainer()->get(UserRepository::class)->findOneBy(['email' => $testData['email']]);
        self::assertNull($user);
    }

    public function testDuplicateEmail(): void
    {
        $testData = [
            'email'     => 'test@test.ru',
            'firstName' => 'Test',
            'lastName'  => 'Testov'
        ];
        static::getClient()->request('POST', '/api/users', [
            'json' => $testData
        ]);
        self::assertResponseStatusCodeSame(201);
        $user = static::getContainer()->get(UserRepository::class)->findOneBy(['email' => $testData['email']]);
        self::assertNotNull($user);

        static::getClient()->request('POST', '/api/users', [
            'json' => $testData
        ]);
        self::assertResponseStatusCodeSame(422);
        $users = static::getContainer()->get(UserRepository::class)->findBy(['email' => $testData['email']]);
        self::assertCount(1, $users);
    }
}
