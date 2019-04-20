FROM php:7.1-fpm

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ssmtp \
        libfreetype6-dev \
        libicu-dev \
        libjpeg-dev \
        libmcrypt-dev \
        libmagickwand-dev \
        libpng-dev \
        libxml2-dev \
        libxslt1-dev && \
    apt-get clean

RUN docker-php-ext-install -j$(nproc) bcmath intl mcrypt opcache pdo_mysql soap xsl zip && \
    docker-php-ext-configure gd --with-jpeg-dir=/usr/include/ --with-freetype-dir=/usr/include/ && \
    docker-php-ext-install -j$(nproc) gd && \
    pecl install imagick && \
    pecl install xdebug && \
    docker-php-ext-enable imagick xdebug

COPY www.conf /usr/local/etc/php-fpm.d/www.conf
COPY php.ini /usr/local/etc/php/php.ini
COPY ssmtp.conf /etc/ssmtp/ssmtp.conf

RUN chmod 644 /usr/local/etc/php-fpm.d/www.conf && \
    chmod 644 /usr/local/etc/php/php.ini && \
    chmod 644 /etc/ssmtp/ssmtp.conf

RUN curl https://getcomposer.org/installer | \
    php -- \
        --install-dir=/usr/local/bin \
        --filename=composer

RUN curl -o /usr/local/bin/magerun https://files.magerun.net/n98-magerun2.phar && \
    chmod 755 /usr/local/bin/magerun

ARG USER_ID

RUN test -n "${USER_ID:?}" && \
    mkdir -p /var/www/magento && \
    chmod -R 750 /var/www && \
    groupadd --gid $USER_ID magento && \
    useradd --home /var/www --uid $USER_ID --gid $USER_ID magento && \
    chown -R magento:magento /var/www

WORKDIR /var/www/magento
EXPOSE 9000
