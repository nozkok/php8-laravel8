FROM php:8.0.13-fpm

MAINTAINER Erkan Ozkok <erkanozkok@gmail.com>

RUN apt-get update
RUN apt-get install -y \
    git \
    zip \
    curl \
    sudo \
    unzip \
    supervisor \
    libicu-dev \
    libbz2-dev \
    libpng-dev \
    libzip-dev \
    libjpeg-dev \
    libxml2-dev \
    libonig-dev \
    libmcrypt-dev \
    libreadline-dev \
    libfreetype6-dev \
    g++ \
    nano

RUN docker-php-ext-install \
    pdo_mysql \
    gd \
    zip \
    bz2 \
    soap \
    intl \
    ctype \
    bcmath \
    opcache \
    calendar \
    fileinfo \
    tokenizer \
    mbstring

RUN pecl install redis && docker-php-ext-enable redis

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN rm -rf /var/cache/apk/*

RUN chown -R www-data:www-data /var/www

RUN echo "alias t='/var/www/vendor/bin/phpunit'" >> ~/.bashrc
RUN echo "alias f='t --filter'" >> ~/.bashrc
RUN echo "alias pa='php artisan'" >> ~/.bashrc
RUN echo "alias mfs='pa migrate:fresh --seed'" >> ~/.bashrc
RUN echo "alias fulltest='composer install; pa migrate:fresh-seed-with-data; t;'" >> ~/.bashrc
RUN echo "alias migratedata='pa migrate;  pa migrate --force --path=database/migrations/data'" >> ~/.bashrc

WORKDIR /var/www
