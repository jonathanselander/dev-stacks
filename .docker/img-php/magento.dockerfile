FROM debian:10-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        lsb-release && \
    curl -o /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

ARG PHP_VERSION
RUN test -n "${PHP_VERSION:?}"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        php$PHP_VERSION-common \
        php$PHP_VERSION-cli \
        php$PHP_VERSION-fpm \
        php$PHP_VERSION-curl \
        php$PHP_VERSION-bcmath \
        php$PHP_VERSION-gd \
        php$PHP_VERSION-imagick \
        php$PHP_VERSION-intl \
        php$PHP_VERSION-mbstring \
        $(dpkg --compare-versions "$PHP_VERSION" lt 7.2 && echo php$PHP_VERSION-mcrypt) \
        php$PHP_VERSION-mysql \
        php$PHP_VERSION-opcache \
        php$PHP_VERSION-soap \
        php$PHP_VERSION-xdebug \
        php$PHP_VERSION-xsl \
        php$PHP_VERSION-zip

RUN apt-get install -y --no-install-recommends \
        git \
        patch \
        msmtp-mta \
        unzip

COPY www.conf /etc/php/$PHP_VERSION/fpm/pool.d/www.conf
COPY php.ini /etc/php/$PHP_VERSION/fpm/php.ini
COPY php.ini /etc/php/$PHP_VERSION/cli/php.ini

RUN chmod 644 /etc/php/$PHP_VERSION/fpm/pool.d/www.conf && \
    chmod 644 /etc/php/$PHP_VERSION/fpm/php.ini && \
    chmod 644 /etc/php/$PHP_VERSION/cli/php.ini

RUN curl https://getcomposer.org/installer | \
    php -- \
        --install-dir=/usr/local/bin \
        --filename=composer

RUN curl -o /usr/local/bin/magerun https://files.magerun.net/n98-magerun2.phar && \
    chmod 755 /usr/local/bin/magerun

ARG USER_ID
ARG USER_NAME

RUN test -n "${USER_ID:?}" && test -n "${USER_NAME:?}"

RUN mkdir -p /home/$USER_NAME && \
    chmod -R 755 /home/$USER_NAME && \
    groupadd --gid $USER_ID $USER_NAME && \
    useradd --home /home/$USER_NAME --uid $USER_ID --gid $USER_ID $USER_NAME && \
    chown -R $USER_NAME:$USER_NAME /home/$USER_NAME && \
    mkdir -p /srv/$USER_NAME && \
    chmod -R 755 /srv/$USER_NAME && \
    chown -R $USER_NAME:$USER_NAME /srv/$USER_NAME

RUN mkdir -p /run/php && \
    chmod -R 755 /run/php && \
    chown -R $USER_NAME:$USER_NAME /run/php && \
    ln -s /usr/sbin/php-fpm$PHP_VERSION /usr/sbin/php-fpm

USER $USER_NAME:$USER_NAME
WORKDIR /srv/$USER_NAME

ENTRYPOINT ["php-fpm", "-F"]
EXPOSE 9000
