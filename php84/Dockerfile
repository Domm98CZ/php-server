FROM php:8.4.7-apache-bookworm

# Basic debian-buster settings
ARG DEBIAN_FRONTEND=noninteractive
ARG ACCEPT_EULA=Y

# App
ENV PHP_APPLICATION_DIR='/var/www/app'

# Prepare wkhtmltox
ENV PHP_WKHTMLTOX_VERSION='0.12.6.1-3'

# Insert configuration
COPY ./php.ini ${PHP_INI_DIR}/conf.d/php-server-settings.ini
RUN chmod 644 ${PHP_INI_DIR}/conf.d/php-server-settings.ini

# Insert scripts
COPY ./scripts/* /usr/bin/

# Imagick
ENV     PHP_IMAGICK_VERSION='3.7.0'

# NPM add path
ENV     PHP_NVM_DIR /usr/local/nvm
ENV     PHP_NODE_VERSION 23.3.0

ENV     PATH="/usr/local/sbin:${PATH}"
ENV     PATH="/usr/local/bin:${PATH}"

ENV     NODE_PATH ${PHP_NVM_DIR}/v${PHP_NODE_VERSION}/lib/node_modules
ENV     PATH      ${PHP_NVM_DIR}/versions/node/v${EVO_NODE_VERSION}/bin/:${PATH}
ENV     PATH      ${PHP_NVM_DIR}/v${PHP_NODE_VERSION}/bin:${PATH}

# Run update
RUN apt-get -y update \
    && touch /etc/apt/sources.list \
    && cp /etc/apt/sources.list /etc/apt/sources.list~ \
    && sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

# Run update & upgrade & get packages
RUN apt-get update && apt-get upgrade -y \
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
    python-is-python3 \
    libpq-dev \
    libldap2-dev \
    libtiff-dev \
    libicu-dev \
    libmagickwand-dev \
    libmagickcore-dev \
    imagemagick \
    zlib1g-dev \
    # PHP Extensions dependencies
    gnupg \
    libzip-dev \
    zip \
    libmcrypt-dev \
    libxml2-dev \
    # GD
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libjpeg-dev \
    libpng-dev \
    libwebp-dev \
    libxpm-dev

# Locale
RUN     apt-get update
RUN     apt-get install -y locales
RUN     sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen
RUN     locale-gen
RUN     echo "export LC_ALL=en_US.UTF-8" >> ~/.bashrc
RUN     echo "export LANG=en_US.UTF-8" >> ~/.bashrc
RUN     echo "export LANGUAGE=en_US.UTF-8" >> ~/.bashrc

# Install NPM
RUN     curl -fsSL https://deb.nodesource.com/setup_current.x | bash -
ENV     PATH="${PHP_NVM_DIR}/versions/node/v${PHP_NODE_VERSION}/bin/:${PATH}"
RUN     apt-get update && apt-get install -y \
        nodejs \
        software-properties-common

RUN     npm install n -g
RUN     npm install npm@latest -g
RUN     n stable

# Prepare scripts
RUN echo "alias agi='apt-get install'" >> ~/.bashrc \
    && for file in /usr/bin/*.sh; do mv -- ${file} ${file%%.sh} && chmod u+x ${file%%.sh}; done \
    && echo "alias rmc='clearCache'" >> ~/.bashrc \
    && echo "alias ..='cd ..'" >> ~/.bashrc \
    && echo "alias c='clear'" >> ~/.bashrc \
    && echo "alias ll='ls -l'" >> ~/.bashrc \
    && echo "alias lf='ls -F'" >> ~/.bashrc \
    && echo "alias lsz='du -sh * | sort -h'" >> ~/.bashrc \
    && echo "alias untar='tar -zxvf'" >> ~/.bashrc \
    && echo "alias h='history'" >> ~/.bashrc \
    && echo "alias hg='history | grep'" >> ~/.bashrc \
    && echo "alias j='jobs -l'" >> ~/.bashrc \
    && echo "alias update='apt-get update && apt-get upgrade'" >> ~/.bashrc \
    && echo "alias nowtime='date +\"%T\"'" >> ~/.bashrc \
    && echo "alias nowdate='date +\"%d-%m-%Y\"'" >> ~/.bashrc \
    && echo "alias cda='cd ${PHP_APPLICATION_DIR}'" >> ~/.bashrc \
    && echo "alias cdaw='cd ${PHP_APPLICATION_DIR}/www'" >> ~/.bashrc \
    && echo "alias cu='composer update'" >> ~/.bashrc \
    && echo "alias ci='composer install'" >> ~/.bashrc \
    && echo "alias ni='npm install'" >> ~/.bashrc \
    && echo "alias nu='npm update'" >> ~/.bashrc \
    && echo "alias rms='rm -i'" >> ~/.bashrc \
    && echo "alias cps='cp -i'" >> ~/.bashrc \
    && echo "alias mvs='mv -i'" >> ~/.bashrc \
    && /bin/bash -ic "source ~/.bashrc"

# Install wkHtmlToPdf
RUN   wget https://github.com/wkhtmltopdf/packaging/releases/download/${PHP_WKHTMLTOX_VERSION}/wkhtmltox_${PHP_WKHTMLTOX_VERSION}.bookworm_amd64.deb \
        && apt -qy install ./wkhtmltox_${PHP_WKHTMLTOX_VERSION}.bookworm_amd64.deb \
        && rm wkhtmltox_${PHP_WKHTMLTOX_VERSION}.bookworm_amd64.deb

# Use the default production php configuration
RUN mv "${PHP_INI_DIR}/php.ini-production" "${PHP_INI_DIR}/php.ini" && \
    sed -i 's/expose_php = On/expose_php = Off/g' ${PHP_INI_DIR}/php.ini

# Microsoft SQL Drivers dependencies
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update && apt-get -y --no-install-recommends install \
    unixodbc-dev \
    msodbcsql17 \
    libtool

# Install php extensions
RUN docker-php-ext-configure zip \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure exif \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && export PHP_DTRACE=yes \
    # Install PHP extensions
    && docker-php-ext-install \
        zip \
        soap \
        exif \
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
#    && pecl install xdebug-3.2.0RC1 \
#    && docker-php-ext-enable xdebug \
    # OPCACHE
    && docker-php-ext-install opcache \
    && docker-php-ext-enable opcache
# Enable PHP GD with Freetype support
RUN     docker-php-ext-configure gd \
            --with-freetype \
            --with-jpeg=/usr/include/ \
        && docker-php-ext-install gd

# Enable Imagick
#RUN pecl install imagick \
#    && docker-php-ext-enable imagick

# Enable Imagick (build)
RUN   mkdir -p /usr/src/php/ext/imagick \
       && curl -fsSL https://pecl.php.net/get/imagick-${PHP_IMAGICK_VERSION}.tgz | tar xvz -C "/usr/src/php/ext/imagick" --strip 1 \
       && docker-php-ext-install imagick

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

# Clean up
RUN apt-get clean \
    && apt-get autoclean \
    && npm cache clean -f \
    && rm -rf /tmp/*
