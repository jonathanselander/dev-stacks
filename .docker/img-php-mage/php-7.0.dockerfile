FROM debian:9-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        lsb-release && \
    curl -o /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        php7.0-common \
        php7.0-cli \
        php7.0-fpm \
        php7.0-curl \
        php7.0-bcmath \
        php7.0-gd \
        php7.0-imagick \
        php7.0-intl \
        php7.0-mbstring \
        php7.0-mcrypt \
        php7.0-mysql \
        php7.0-opcache \
        php7.0-soap \
        php7.0-xdebug \
        php7.0-xsl \
        php7.0-zip

RUN apt-get install -y --no-install-recommends \
        ssmtp && \
    apt-get clean

COPY www.conf /etc/php/7.0/fpm/pool.d/www.conf
COPY php.ini /etc/php/7.0/fpm/php.ini
COPY php.ini /etc/php/7.0/cli/php.ini
COPY ssmtp.conf /etc/ssmtp/ssmtp.conf

RUN chmod 644 /etc/php/7.0/fpm/pool.d/www.conf && \
    chmod 644 /etc/php/7.0/fpm/php.ini && \
    chmod 644 /etc/php/7.0/cli/php.ini && \
    chmod 644 /etc/ssmtp/ssmtp.conf

RUN curl https://getcomposer.org/installer | \
    php -- \
        --install-dir=/usr/local/bin \
        --filename=composer

RUN curl -o /usr/local/bin/magerun https://files.magerun.net/n98-magerun2.phar && \
    chmod 755 /usr/local/bin/magerun

RUN curl -o /usr/local/bin/magerun1 https://files.magerun.net/n98-magerun.phar && \
    chmod 755 /usr/local/bin/magerun1

ARG USER_ID

RUN test -n "${USER_ID:?}" && \
    mkdir -p /srv/magento && \
    chmod -R 755 /srv/magento && \
    groupadd --gid $USER_ID magento && \
    useradd --home /srv/magento --uid $USER_ID --gid $USER_ID magento && \
    chown -R magento:magento /srv/magento

RUN mkdir -p /run/php && \
    chmod -R 755 /run/php && \
    chown -R magento:magento /run/php

USER magento:magento
WORKDIR /srv/magento

ENTRYPOINT ["php-fpm7.0", "-F"]
EXPOSE 9000
