FROM openmandriva/cooker
ENV RARCH x86_64

RUN dnf --nogpgcheck --refresh --assumeyes --nodocs --setopt=install_weak_deps=False upgrade \
 && rm -f /etc/localtime \
 && ln -s /usr/share/zoneinfo/UTC /etc/localtime \
 && dnf --nogpgcheck --assumeyes --nodocs --setopt=install_weak_deps=False install createrepo_c dnf-utils gnupg openmandriva-repos-keys \
 && dnf autoremove --assumeyes \
 && dnf clean all \
 && rm -rf /var/cache/dnf/* \
 && rm -rf /var/lib/dnf/yumdb/* \
 && rm -rf /var/lib/dnf/history/* \
 && rm -rf /tmp/* \
 && rm -rf /var/lib/rpm/__db.* \
 && rm -rf /usr/share/man/ /usr/share/cracklib /usr/share/doc /usr/share/locale/

COPY entrypoint.sh /sbin/entrypoint.sh
ENTRYPOINT ["/sbin/entrypoint.sh"]
