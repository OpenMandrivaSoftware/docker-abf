FROM rosalab/rosa2021.1:aarch64

RUN dnf --nogpgcheck --refresh --assumeyes --nodocs --setopt=install_weak_deps=False upgrade
RUN dnf --nogpgcheck --assumeyes --setopt=install_weak_deps=False --nodocs install mock git coreutils curl sudo basesystem-build
RUN dnf --nogpgcheck --assumeyes --setopt=install_weak_deps=False --nodocs install java-11-openjdk e2fsprogs os-prober dmsetup xorriso livecd-tools
RUN rm -rf /var/cache/dnf/* \&&rm -rf /var/lib/dnf/yumdb/*
RUN rm -rf /var/lib/dnf/yumdb/*
RUN rm -rf /var/lib/dnf/history/*
RUN rm -rf /usr/share/man/ /usr/share/cracklib /usr/share/doc /usr/share/licenses /tmp/*

WORKDIR /

COPY entrypoint.sh /sbin/entrypoint.sh
COPY telegram_send.py /usr/bin/telegram_send.py
COPY fstore_upload.sh /usr/bin/fstore_upload
ENTRYPOINT ["/sbin/entrypoint.sh"]
