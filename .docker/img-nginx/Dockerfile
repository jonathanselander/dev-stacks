FROM nginx:stable

ARG USER_ID
ARG APP_NAME

RUN test -n "${USER_ID:?}" && test -n "${APP_NAME:?}" && \
    mkdir -p /var/www/$APP_NAME && \
    chmod -R 750 /var/www && \
    groupadd --gid $USER_ID $APP_NAME && \
    useradd --home /var/www --uid $USER_ID --gid $USER_ID $APP_NAME && \
    chown -R $APP_NAME:$APP_NAME /var/www

WORKDIR /var/www/$APP_NAME

EXPOSE 80
EXPOSE 8080
