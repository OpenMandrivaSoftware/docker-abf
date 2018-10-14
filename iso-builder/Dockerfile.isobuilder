FROM openmandriva/cooker

RUN dnf update -y --nogpgcheck \
 && dnf install -y --nogpgcheck gnupg sudo mock git which findutils sed parallel curl docker rubygems dosfstools squashfs-tools \
 && rm -f /etc/localtime \
 && ln -s /usr/share/zoneinfo/UTC /etc/localtime \
 && sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers \
 && echo "%mock ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && adduser omv \
 && usermod -a -G mock omv \
 && usermod -a -G docker omv \
 && chown -R omv:mock /etc/mock \
 && rm -rf /var/lib/dnf/history/* \
 && rm -rf /usr/share/man/ /usr/share/cracklib /usr/share/doc /tmp/*

USER omv
ENV HOME /home/omv

COPY entrypoint.sh /sbin/entrypoint.sh
ENTRYPOINT ["/sbin/entrypoint.sh"]
