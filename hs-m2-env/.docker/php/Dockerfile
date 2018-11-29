FROM php:7.1-fpm

RUN apt-get update && \
    apt-get install -y ssmtp \
                       libmcrypt-dev \
                       libxml2-dev \
                       libpng-dev \
                       libjpeg-dev \
                       libfreetype6-dev \
                       libicu-dev \
                       libxslt1-dev && \
    apt-get clean

RUN docker-php-ext-install pdo_mysql mcrypt soap intl xsl zip opcache bcmath && \
    docker-php-ext-configure gd --with-jpeg-dir=/usr/include/ --with-freetype-dir=/usr/include/ && \
    docker-php-ext-install gd && \
    pecl install xdebug && \
    docker-php-ext-enable xdebug

RUN curl -sS https://getcomposer.org/installer | \
    php -- \
      --install-dir=/usr/local/bin \
      --filename=composer

RUN curl -sS -o /usr/local/bin/magerun https://files.magerun.net/n98-magerun2.phar && \
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
