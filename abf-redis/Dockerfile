# Parts shamelessly stolen from
# https://hub.docker.com/r/sameersbn/redis/dockerfile

FROM openmandriva/cooker:latest
MAINTAINER Bernhard Rosenkränzer <bero@lindev.ch>

ENV REDIS_USER=redis \
    REDIS_DATA_DIR=/var/lib/redis \
    REDIS_LOG_DIR=/var/log/redis

RUN dnf --refresh install --nogpgcheck --assumeyes --nodocs --setopt=install_weak_deps=False redis \
 && sed 's/^bind /# bind /' -i /etc/redis.conf \
 && sed 's/^logfile /# logfile /' -i /etc/redis.conf \
 && sed 's/^protected-mode yes/protected-mode no/' -i /etc/redis.conf \
 && sed 's/^# unixsocket /unixsocket /' -i /etc/redis.conf \
 && sed 's/^# unixsocketperm 700/unixsocketperm 777/' -i /etc/redis.conf \
 && dnf clean all \
 && chown redis /usr/bin/redis-server \
 && chmod 4755 /usr/bin/redis-server

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 6379/tcp
ENTRYPOINT ["/sbin/entrypoint.sh"]
