FROM debian:9-slim

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
        unzip \
        ssmtp

COPY www.conf /etc/php/$PHP_VERSION/fpm/pool.d/www.conf
COPY php.ini /etc/php/$PHP_VERSION/fpm/php.ini
COPY php.ini /etc/php/$PHP_VERSION/cli/php.ini
COPY ssmtp.conf /etc/ssmtp/ssmtp.conf

RUN chmod 644 /etc/php/$PHP_VERSION/fpm/pool.d/www.conf && \
    chmod 644 /etc/php/$PHP_VERSION/fpm/php.ini && \
    chmod 644 /etc/php/$PHP_VERSION/cli/php.ini && \
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
    chown -R magento:magento /srv/magento

RUN mkdir -p /run/php && \
    chmod -R 755 /run/php && \
    chown -R magento:magento /run/php && \
    ln -s /usr/sbin/php-fpm$PHP_VERSION /usr/sbin/php-fpm

USER magento:magento
WORKDIR /srv/magento

ENTRYPOINT ["php-fpm", "-F"]
EXPOSE 9000
