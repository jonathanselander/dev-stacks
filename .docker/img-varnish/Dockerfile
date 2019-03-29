FROM debian:9

RUN apt update && apt install -y varnish

VOLUME /var/lib/varnish
EXPOSE 80

ENTRYPOINT ["/usr/sbin/varnishd","-j","unix","-F"]
CMD ["-s","malloc,2g","-a","0.0.0.0:80","-f","/etc/varnish/default.vcl"]
