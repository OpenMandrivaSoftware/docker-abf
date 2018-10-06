FROM openmandriva/cooker

RUN dnf update -y --nogpgcheck \
 && dnf install -y --nogpgcheck git ruby lib64xslt-devel timezone rubygems postgresql-devel ruby-devel clang glibc-devel make zlib-devel \
 && rm -f /etc/localtime \
 && ln -s /usr/share/zoneinfo/UTC /etc/localtime \
 && rm -rf /var/lib/dnf/history/* /usr/share/locale /usr/share/info \
 && rm -rf /usr/share/man/ /usr/share/cracklib /usr/share/doc /tmp/*

COPY entrypoint.sh /sbin/entrypoint.sh
ENTRYPOINT ["/sbin/entrypoint.sh"]
