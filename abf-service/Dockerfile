FROM openmandriva/cooker

RUN dnf --nogpgcheck --refresh --assumeyes --nodocs --setopt=install_weak_deps=False upgrade \
 && dnf --nogpgcheck --assumeyes --nodocs --setopt=install_weak_deps=False install git lib64xslt-devel timezone 'rubygems < 3.0.0' postgresql-devel ruby2-devel clang glibc-devel make zlib-devel \
 && rm -f /etc/localtime \
 && ln -s /usr/share/zoneinfo/UTC /etc/localtime \
 && rm -rf /var/cache/dnf/* \
 && rm -rf /var/lib/dnf/* \
 && rm -rf /tmp/* \
 && rm -rf /var/lib/rpm/__db.* \
 && rm -rf /usr/share/man /usr/share/info/ /usr/share/cracklib /usr/share/doc /usr/share/locale/

COPY entrypoint.sh /sbin/entrypoint.sh
ENTRYPOINT ["/sbin/entrypoint.sh"]
