config_path = dev/docker

app_env = dev
test_env = test

app_uid ?= `id -u`
app_gid ?= `id -g`

build_args = --build-arg APP_UID=$(app_uid) --build-arg APP_GID=$(app_gid)

application_service_name ?= php

nodejs_service_name ?= node

cmd ?= echo Usage: make app-run cmd=whoami

test_args ?=

usage:
	@echo "make install - prepares development environment from the scratch"
	@echo "make init-envs - make .env files for development"
	@echo "make build - build all containers"
	@echo "make rebuild - rebuild all containers"
	@echo "make up - start all containers in daemon mode"
	@echo "make start - start containers"
	@echo "make stop - stop containers"
	@echo "make down - stop containers"
	@echo "make app-shell - run terminal php container"
	@echo "make app-run - run command in php container"
	@echo "make migrate - migrate database in dev env"
	@echo "make migrate-test - migrate database in test env"
	@echo "make clear - clear cache"
	@echo "make clear-logs - clear logs"
	@echo "make assets - install assets"
	@echo "make test - run tests"
	@echo "make test-functional - run only functional tests"
	@echo "make test-unit - run only unit tests"
	@echo "make fixtures - load migrations and fixtures in dev env"
	@echo "make fixtures-test - load migrations and fixtures in test env"

install: init-envs build up migrate migrate-test

init-envs:
ifeq (,$(wildcard $(config_path)/.env))
	cp $(config_path)/.env.dist $(config_path)/.env
endif
ifeq (,$(wildcard .env.local))
	echo "APP_ENV=dev" > .env.local
endif

build:
	cd $(config_path) && docker-compose build $(build_args)

rebuild:
	cd $(config_path) && docker-compose build --no-cache $(build_args)

up:
	cd $(config_path) && docker-compose up -d --remove-orphans --renew-anon-volumes

start:
	cd $(config_path) && docker-compose start

stop:
	cd $(config_path) && docker-compose stop

down:
	cd $(config_path) && docker-compose down --remove-orphans

app-shell:
	cd $(config_path) && docker-compose exec $(application_service_name) bash

app-run:
	cd $(config_path) && docker-compose exec $(application_service_name) bash -c '$(cmd)'

migrate:
	cd $(config_path) && docker-compose exec $(application_service_name) php ./bin/console doctrine:migrations:migrate -n --env $(app_env)

migrate-test:
	cd $(config_path) && docker-compose exec $(application_service_name) php ./bin/console doctrine:migrations:migrate -n --env $(test_env)

clear:
	cd $(config_path) && docker-compose exec $(application_service_name) php ./bin/console cache:clear --env $(app_env)

clear-test:
	cd $(config_path) && docker-compose exec $(application_service_name) php ./bin/console cache:clear --env $(test_env)

clear-logs:
	rm -f var/log/*.log

assets:
	cd $(config_path) && docker-compose exec $(application_service_name) php ./bin/console assets:install --env $(app_env)

test:
	cd $(config_path) && docker-compose exec $(application_service_name) ./bin/phpunit $(test_args)

test-functional:
	cd $(config_path) && docker-compose exec $(application_service_name) ./bin/phpunit $(test_args) tests/functional

test-unit:
	cd $(config_path) && docker-compose exec $(application_service_name) ./bin/phpunit $(test_args) tests/unit

fixtures: migrate
	cd $(config_path) && docker-compose exec $(application_service_name) php ./bin/console doctrine:fixtures:load -n --env $(app_env)

fixtures-test: migrate-test
	cd $(config_path) && docker-compose exec $(application_service_name) php ./bin/console doctrine:fixtures:load -n --env $(test_env)

yarn-install:
	cd $(config_path) && docker-compose run --rm $(nodejs_service_name) yarn install

yarn-start:
	cd $(config_path) && docker-compose run --rm --publish 8081:8081 $(nodejs_service_name) yarn start

yarn-build:
	cd $(config_path) && docker-compose run --rm $(nodejs_service_name) yarn build

yarn-shell:
	cd $(config_path) && docker-compose run --rm $(nodejs_service_name) sh

