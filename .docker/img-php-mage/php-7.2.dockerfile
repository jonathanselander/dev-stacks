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
        php7.2-common \
        php7.2-cli \
        php7.2-fpm \
        php7.2-curl \
        php7.2-bcmath \
        php7.2-gd \
        php7.2-imagick \
        php7.2-intl \
        php7.2-mbstring \
        php7.2-mysql \
        php7.2-opcache \
        php7.2-soap \
        php7.2-xdebug \
        php7.2-xsl \
        php7.2-zip

RUN apt-get install -y --no-install-recommends \
        git \
        unzip \
        ssmtp

COPY www.conf /etc/php/7.2/fpm/pool.d/www.conf
COPY php.ini /etc/php/7.2/fpm/php.ini
COPY php.ini /etc/php/7.2/cli/php.ini
COPY ssmtp.conf /etc/ssmtp/ssmtp.conf

RUN chmod 644 /etc/php/7.2/fpm/pool.d/www.conf && \
    chmod 644 /etc/php/7.2/fpm/php.ini && \
    chmod 644 /etc/php/7.2/cli/php.ini && \
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
    mkdir -p /home/magento && \
    chmod -R 755 /home/magento && \
    groupadd --gid $USER_ID magento && \
    useradd --home /home/magento --uid $USER_ID --gid $USER_ID magento && \
    chown -R magento:magento /home/magento && \
    mkdir -p /srv/magento && \
    chmod -R 755 /srv/magento && \
    chown -R magento:magento /srv/magento && \
    mkdir -p /run/php && \
    chmod -R 755 /run/php && \
    chown -R magento:magento /run/php

USER magento:magento
WORKDIR /srv/magento

ENTRYPOINT ["php-fpm7.2", "-F"]
EXPOSE 9000
