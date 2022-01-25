# REFERENCE: https://github.com/TrafeX/docker-php-nginx/blob/master/Dockerfile

FROM alpine:3.15

RUN apk --update add --no-cache \
        ttf-dejavu ttf-droid ttf-freefont ttf-liberation \
        nginx \
        curl \
        supervisor \
        php8 \
        php8-ctype \
        php8-curl \
        php8-dom \
        php8-fpm \
        php8-bz2 \
        php8-gd \
        php8-intl \
        php8-json \
        php8-mbstring \
        php8-opcache \
        php8-openssl \
        php8-phar \
        php8-session \
        php8-xml \
        php8-xmlreader \
        php8-xmlwriter \
        php8-zlib \
        php8-exif \
        php8-iconv \
        php8-pdo \
        php8-pdo_mysql \
        php8-pdo_pgsql \
        php8-pdo_sqlite \
        php8-session \
        php8-tokenizer \
        php8-gettext \
        php8-fileinfo \
        php8-soap \
        php8-bcmath \
        php8-calendar \
        php8-gmp \
        php8-simplexml \
        php8-zip 

# Create symlink so programs depending on `php` still function
RUN ln -s /usr/bin/php8 /usr/bin/php

COPY config/fpm-pool.conf /etc/php8/php-fpm.d/www.conf
COPY config/php.ini /etc/php8/conf.d/custom.ini

RUN apk add gnu-libiconv --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# Clear install cache
RUN rm -Rf /var/cache/apk/*

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /app

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /app && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/log/nginx

USER nobody

WORKDIR /app


RUN chmod -R 755 /app
EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping