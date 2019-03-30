FROM debian:9

RUN apt-get update && \
    apt-get install -y varnish && \
    apt-get clean

VOLUME /var/lib/varnish
EXPOSE 80

ENTRYPOINT ["/usr/sbin/varnishd","-j","unix","-F"]
CMD ["-s","malloc,2g","-a","0.0.0.0:80","-f","/etc/varnish/default.vcl"]
