FROM php:7.2-fpm

RUN apt-get update && \
    apt-get install -y ssmtp libfreetype6-dev libjpeg-dev libmcrypt-dev libpng-dev libxml2-dev && \
    apt-get clean

RUN docker-php-ext-install pdo_mysql soap opcache && \
    docker-php-ext-configure gd --with-jpeg-dir=/usr/include/ --with-freetype-dir=/usr/include/ && \
    docker-php-ext-install gd && \
    pecl install mcrypt-snapshot && \
    pecl install xdebug && \
    docker-php-ext-enable mcrypt xdebug

RUN curl https://getcomposer.org/installer | \
    php -- \
        --install-dir=/usr/local/bin \
        --filename=composer

RUN curl -o /usr/local/bin/magerun https://files.magerun.net/n98-magerun.phar && \
    chmod 755 /usr/local/bin/magerun

COPY www.conf /usr/local/etc/php-fpm.d/www.conf
COPY php.ini /usr/local/etc/php/php.ini
COPY ssmtp.conf /etc/ssmtp/ssmtp.conf

RUN chmod 644 /usr/local/etc/php-fpm.d/www.conf && \
    chmod 644 /usr/local/etc/php/php.ini && \
    chmod 644 /etc/ssmtp/ssmtp.conf

ARG uid=1000
ARG gid=1000

RUN mkdir -p /var/www/magento && \
    chmod -R 750 /var/www && \
    groupadd --gid $gid magento && \
    useradd --home /var/www --uid $uid --gid $gid magento && \
    chown -R magento:magento /var/www

WORKDIR /var/www/magento
EXPOSE 9000
