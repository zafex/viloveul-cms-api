FROM debian:stretch-slim

MAINTAINER Fajrul Akbar Zuhdi<fajrulaz@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
    apt-utils \
    lsb-release \
    gnupg \
    autoconf \
    apt-transport-https \
    ca-certificates \
    dpkg-dev \
    file \
    g++ \
    gcc \
    libc-dev \
    make \
    pkg-config \
    re2c \
    curl \
    nano \
    wget \
    zip \
    unzip \
    cron \
    supervisor

ADD . /viloveul

WORKDIR /viloveul

RUN apt-get install -y --no-install-recommends --no-install-suggests nginx && \
    rm -f /etc/nginx/sites-enabled/* && \
    cp /viloveul/config/nginx.conf /etc/nginx/conf.d/default.conf && \
    mkdir -p /var/log/supervisor && \
    touch /viloveul/.env

RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php stretch main" | tee /etc/apt/sources.list.d/php7.3.list

RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
    mariadb-server \
    php7.3-common \
    php7.3-dev \
    php7.3-cli \
    php7.3-fpm \
    php7.3-zip \
    php7.3-xml \
    php7.3-mysql \
    php7.3-mbstring \
    php7.3-intl \
    php7.3-gd \
    php7.3-curl \
    php7.3-bcmath \
    php-pear \
    php-amqp

ENV COMPOSER_ALLOW_SUPERUSER 1

ENV VILOVEUL_DB_HOST=localhost
ENV VILOVEUL_DB_NAME=viloveul
ENV VILOVEUL_DB_USERNAME=dev
ENV VILOVEUL_DB_PASSWD=viloveul

RUN pecl install apcu && \
    echo "extension=apcu.so" > /etc/php/7.3/mods-available/apcu.ini && \
    phpenmod apcu && \
    php -r "copy('https://getcomposer.org/installer', '/tmp/composer-setup.php');" && \
    php /tmp/composer-setup.php --install-dir=/usr/bin/ --filename=composer && \
    composer install --no-dev --working-dir=/viloveul && \
    composer run bootstrap --working-dir=/viloveul && \
    composer clear-cache && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    mkdir -p /var/run/php

EXPOSE 19911 3306

CMD ["sh", "/viloveul/sbin/docker"]