FROM debian:buster-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl

ARG NODE_VERSION
RUN test -n "${NODE_VERSION:?}"

RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION:?}.x | bash - && \
    apt-get update && apt-get install -y --no-install-recommends nodejs

ARG USER_ID
RUN test -n "${USER_ID:?}"

RUN mkdir -p /home/frontend && \
    chmod -R 755 /home/frontend && \
    groupadd --gid $USER_ID frontend && \
    useradd --home /home/frontend --uid $USER_ID --gid $USER_ID frontend && \
    chown -R frontend:frontend /home/frontend && \
    mkdir -p /srv/frontend && \
    chmod -R 755 /srv/frontend && \
    chown -R frontend:frontend /srv/frontend

USER frontend:frontend
WORKDIR /srv/frontend

ENTRYPOINT ["npm", "run", "dev"]
EXPOSE 8000
