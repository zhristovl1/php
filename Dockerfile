ARG PHP_VERSION=8.2.28
ARG PHP_VARIANT=cli-alpine
ARG COMPOSER_VERSION=2.8.8

FROM composer:${COMPOSER_VERSION} AS composer

FROM php:${PHP_VERSION}-${PHP_VARIANT} AS base

ARG OS_PACKAGES="bash curl git make nano"
ARG PHP_EXTENSIONS="pdo_mysql pdo_pgsql opcache pcntl"

COPY --from=composer /usr/bin/composer /usr/bin/composer

ADD --chmod=0755 \
    https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions \
    /usr/local/bin/

RUN apk add --no-cache $OS_PACKAGES && \
    install-php-extensions $PHP_EXTENSIONS

FROM base AS nodejs

RUN apk add --no-cache nodejs-current

FROM base AS xdebug

RUN install-php-extensions pcov xdebug