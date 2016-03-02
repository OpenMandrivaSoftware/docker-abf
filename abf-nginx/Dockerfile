FROM openmandriva/cooker
MAINTAINER alexander@mezon.ru

RUN urpmi --auto --auto-update --no-verify-rpm \
 && rm -f /etc/localtime \
 && ln -s /usr/share/zoneinfo/UTC /etc/localtime \
 && urpmi --no-suggests --no-verify-rpm --auto nginx

EXPOSE 80 443

VOLUME ["/var/log/nginx/"]
CMD ["nginx", "-g", "daemon off;"]
