FROM openmandriva/cooker
MAINTAINER alexander@mezon.ru

ENV RUBY ruby-2.4.1

RUN urpmi.removemedia -a \
    && urpmi.addmedia main http://mirror.yandex.ru/openmandriva/cooker/repository/x86_64/main/release/ \
    && urpmi.addmedia contrib http://mirror.yandex.ru/openmandriva/cooker/repository/x86_64/contrib/release/ \
    && urpmi.update -a \
    && urpmi --auto --no-suggests --no-verify-rpm procps-ng nodejs icu-devel git cmake postgresql-devel curl gnutar wget pkgconfig imagemagick \
    && urpmi --auto --no-suggests --no-verify-rpm patch autoconf lib64yaml-devel lib64ffi-devel autoconf gcc-c++ glibc-devel patch sqlite3-devel readline-devel make automake libtool bison \
    && curl -sSL https://rvm.io/mpapis.asc | gpg --import - \
    && /bin/bash -l -c "curl -L get.rvm.io | bash -s stable" \
    && export PATH=$PATH:/usr/local/rvm/bin/ \
    && /bin/bash -l -c "source /usr/local/rvm/scripts/rvm" \
    && /bin/bash -l -c "rvm install $RUBY" \
    && /bin/bash -l -c "rvm use $RUBY" \
    && rm -rf /var/cache/urpmi/rpms/* /usr/share/man /usr/share/doc

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
WORKDIR /app

# Expose port 443 to the Docker host, so we can access it
# from the outside.
EXPOSE 443

# Configure an entry point, so we don't need to specify
# "bundle exec" for each of our commands.
COPY entrypoint.sh /sbin/entrypoint.sh
ENTRYPOINT ["/sbin/entrypoint.sh"]
