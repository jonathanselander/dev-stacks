FROM debian:9-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-transport-https ca-certificates curl gnupg lsb-release && \
    curl -L https://packagecloud.io/varnishcache/varnish60lts/gpgkey | apt-key add - && \
    echo "deb https://packagecloud.io/varnishcache/varnish60lts/debian/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/varnish.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends varnish && \
    apt-get clean

VOLUME /var/lib/varnish
EXPOSE 80

ENTRYPOINT ["/usr/sbin/varnishd","-j","unix","-F"]
CMD ["-s","malloc,512m","-a","0.0.0.0:80","-f","/etc/varnish/default.vcl"]
