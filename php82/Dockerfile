FROM php:8.2.0RC4-apache-buster

# Basic debian-buster settings
ARG DEBIAN_FRONTEND=noninteractive
ARG ACCEPT_EULA=Y

# Prepare wkhtmltox
ENV PHP_WKHTMLTOX_VERSION='0.12.6-1'
COPY ./drivers/wkhtmltox/wkhtmltox_${PHP_WKHTMLTOX_VERSION}.buster_amd64.deb /tmp/wkhtmltox_${PHP_WKHTMLTOX_VERSION}.buster_amd64.deb


# Prepare opcache
COPY    ./drivers/php_settings/opcache.ini ${PHP_INI_DIR}/conf.d/docker-php-ext-opcache.ini
RUN     chmod 644 ${PHP_INI_DIR}/conf.d/docker-php-ext-opcache.ini

RUN     apt-get -y update \
        && cp /etc/apt/sources.list /etc/apt/sources.list~ \
        && sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

RUN     apt-get update && apt-get upgrade -y \
        && apt-get install -y --no-install-recommends --allow-unauthenticated \
            # Basic container applications
            cmake \
            apt-transport-https \
            lsb-release \
            ca-certificates \
            wget \
            krb5-user \
            libpam-krb5 \
            gnupg \
            nodejs \
            acl \
            git \
            npm \
            cron \
            openssh-client \
            gettext-base \
            unzip \
            supervisor \
            openssl \
            nano \
            mc \
            tmux \
            htop \
            iputils-ping \
            telnet \
            postgresql-client \
            ncdu \
            curl \
            build-essential \
            libsasl2-dev \
            libssl-dev \
            python-minimal \
            zlib1g-dev \
            # PHP Extensions dependencies
            gnupg \
            libzip-dev \
            zip \
            libxml2-dev \
            libpq-dev \
            libfreetype6-dev \
            libmcrypt-dev \
            libjpeg62-turbo-dev \
            libjpeg-dev \
            libpng-dev \
            libldap2-dev \
            libicu-dev

# Use the default production php configuration
RUN     mv "${PHP_INI_DIR}/php.ini-production" "${PHP_INI_DIR}/php.ini" && \
        sed -i 's/expose_php = On/expose_php = Off/g' ${PHP_INI_DIR}/php.ini

# Microsoft SQL Drivers dependencies
RUN     curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
        && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
        && apt-get update && apt-get -y --no-install-recommends install \
            unixodbc-dev \
            msodbcsql17 \
            libtool

# Install php extensions
RUN     docker-php-ext-configure zip \
        && docker-php-ext-configure intl \
        && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
        && export PHP_DTRACE=yes \
        # Install PHP extensions
        && docker-php-ext-install \
            zip \
            soap \
            intl \
            ldap \
            bcmath \
            pdo_mysql \
            pdo pdo_pgsql pgsql \
        # redis
        && pecl install redis \
        && docker-php-ext-enable \
            redis \
        # xDebug \
        && pecl install xdebug \
        && docker-php-ext-enable xdebug \
        # OPCACHE
        && docker-php-ext-install opcache \
        && docker-php-ext-enable opcache \
        # Microsoft ODBC
        && pecl install \
            sqlsrv-5.10.1 \
            pdo_sqlsrv-5.10.1 \
        && docker-php-ext-enable \
            sqlsrv \
            pdo_sqlsrv


# Enable PHP GD with Freetype support
RUN     docker-php-ext-configure gd \
            --with-freetype \
#            --enable-gd-native-ttf \
#            --with-freetype-dir=/usr/include/freetype2 \
#            --with-png-dir=/usr/include \
#            --with-jpeg-dir=/usr/include \
        && docker-php-ext-install gd

# fix openSSL
RUN sed -i -E 's/(CipherString\s*=\s*DEFAULT@SECLEVEL=)2/\11/' /etc/ssl/openssl.cnf

# Install composer
RUN set -e; \
    EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"; \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
    ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"; \
    \
    if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; \
    then \
        >&2 echo 'ERROR: Invalid installer signature'; \
        rm composer-setup.php; \
        exit 1; \
    fi; \
    \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer; \
    rm composer-setup.php; \
    adduser --disabled-password --gecos "" composer; \
    composer self-update;

# Install wkHtmlToPdf
RUN apt-get -qy install /tmp/wkhtmltox_${PHP_WKHTMLTOX_VERSION}.buster_amd64.deb

# Clean up
RUN apt-get clean \
    && apt-get autoclean \
    && npm cache clean -f
