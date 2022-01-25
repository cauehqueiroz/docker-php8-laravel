# Docker PHP 8 / NGINX

A simple PHP8 dockerfile adapted to laravel 8  on a alpine based docker container

Contains:
- PHP-FPM 8
- NGINX
- COMPOSER

# Usage notes

There are 2 importante setups that must be done:

- The working dir should be the root of your Laravel App, and you should mount a VOLUME in `/app` folder.
- The NGINX runs on default 80 port, so you can map a port of your preference.


# Usage examples

Start the container using `docker run`

```
docker run -w="./:/app" -p 8080:80 cauehqueiroz/php8-laravel
```

Or use it on a Docker Compose file:

```
version: '3'
services:
  strider-webserver:
    container_name: strider_webserver
    image: cauehqueiroz/php8-laravel
    volumes:
      - ./:/app
    ports:
      - 8080:80
```
