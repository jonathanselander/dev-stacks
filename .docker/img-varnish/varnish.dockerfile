FROM debian:9-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends varnish && \
    apt-get clean

VOLUME /var/lib/varnish
EXPOSE 80

ENTRYPOINT ["/usr/sbin/varnishd","-j","unix","-F"]
CMD ["-s","malloc,2g","-a","0.0.0.0:80","-f","/etc/varnish/default.vcl"]
