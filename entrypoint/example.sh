#!/bin/sh

if ! [ -f ".env" ]; then
    cp .env.dist .env
fi

if ! [ -d "./vendor" ]; then
    php artisan key:generate
fi

php artisan config:clear

mkdir -p ./storage/logs || true
mkdir -p ./storage/framework || true
mkdir -p ./storage/framework/cache || true
mkdir -p ./storage/framework/sessions || true
mkdir -p ./storage/framework/testing || true
mkdir -p ./storage/framework/views || true


/usr/sbin/httpd -D FOREGROUND
exec "$@"
