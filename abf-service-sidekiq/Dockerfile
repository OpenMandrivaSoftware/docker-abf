FROM openmandriva/abf

RUN rm -f /etc/localtime \
 && ln -s /usr/share/zoneinfo/UTC /etc/localtime \
 && rm -rf /var/lib/dnf/* /usr/share/locale /usr/share/info \
 && rm -rf /usr/share/man/ /usr/share/cracklib /usr/share/doc /tmp/*

COPY entrypoint.sh /sbin/entrypoint.sh
ENTRYPOINT ["/sbin/entrypoint.sh"]
