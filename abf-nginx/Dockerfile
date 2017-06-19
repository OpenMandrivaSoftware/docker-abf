FROM openmandriva/3.0
MAINTAINER alexander@mezon.ru

RUN urpmi --auto --auto-update --no-verify-rpm \
 && rm -f /etc/localtime \
 && ln -s /usr/share/zoneinfo/UTC /etc/localtime \
 && urpmi --no-suggests --no-verify-rpm --auto nginx \
 && rm -rf /var/cache/urpmi/rpms/* \
 && rm -rf /usr/share/man/ /usr/share/cracklib /usr/share/doc /var/lib/rpm

EXPOSE 80 443
VOLUME ["/var/log/nginx/"]
CMD ["nginx", "-g", "daemon off;"]
