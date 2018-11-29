FROM nginx:stable

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY magento.conf /etc/nginx/conf.d/magento.conf

RUN chmod 644 /etc/nginx/nginx.conf && \
    chmod 644 /etc/nginx/conf.d/magento.conf

ARG uid=1000
ARG gid=1000

RUN mkdir -p /var/www/magento && \
    chmod -R 750 /var/www && \
    groupadd --gid $gid magento && \
    useradd --home /var/www --uid $uid --gid $gid magento && \
    chown -R magento:magento /var/www

WORKDIR /var/www/magento
EXPOSE 80
