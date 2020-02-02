FROM composer:1.9 AS composer

FROM php:7.2-fpm
RUN apt-get update && apt-get install -y \
    git \
    mariadb-client \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    zip \
	&& docker-php-ext-install -j$(nproc) iconv pdo_mysql mysqli zip opcache \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) gd

COPY --from=composer /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

ENV PATH="$PATH:/var/www/vendor/bin"

COPY contrib/php/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY contrib/php/uploads.ini /usr/local/etc/php/conf.d/uploads.ini

COPY composer.* ./

RUN composer install --no-scripts --no-autoloader
COPY . ./
RUN chgrp -R www-data storage bootstrap/cache && \
    chmod -R ug+rwx storage bootstrap/cache && \
    composer dump-autoload --no-scripts --optimize

RUN pecl install redis && docker-php-ext-enable redis


