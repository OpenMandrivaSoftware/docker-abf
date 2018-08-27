FROM openmandriva/3.0
MAINTAINER alexander@mezon.ru

ENV RUBY ruby-2.2.3

RUN urpmi.removemedia -a \
    && urpmi.addmedia main http://mirror.yandex.ru/openmandriva/3.0/repository/x86_64/main/release/ \
    && urpmi.addmedia main_up http://mirror.yandex.ru/openmandriva/3.0/repository/x86_64/main/updates/ \ 
    && urpmi.addmedia contrib http://mirror.yandex.ru/openmandriva/3.0/repository/x86_64/contrib/release/ \
    && urpmi.addmedia contrib_up http://mirror.yandex.ru/openmandriva/3.0/repository/x86_64/contrib/updates/ \
    && urpmi.update -a \
    && urpmi --auto --no-suggests --no-verify-rpm procps-ng nodejs icu-devel git cmake postgresql-devel curl gnutar wget pkgconfig imagemagick \
    && urpmi --auto --no-suggests --no-verify-rpm patch autoconf lib64yaml-devel lib64ffi-devel autoconf gcc-c++ glibc-devel patch sqlite3-devel readline-devel make automake libtool bison \
    && curl -sSL https://rvm.io/mpapis.asc | gpg --import - \
    && /bin/bash -l -c "curl -L get.rvm.io | bash -s stable" \
    && export PATH=$PATH:/usr/local/rvm/bin/ \
    && /bin/bash -l -c "source /usr/local/rvm/scripts/rvm" \
    && /bin/bash -l -c "rvm install $RUBY" \
    && /bin/bash -l -c "rvm --default use $RUBY" \
    && rm -rf /var/cache/urpmi/rpms/* /usr/share/man /usr/share/doc /usr/share/locale/

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
WORKDIR /file_store

# Configure an entry point, so we don't need to specify
# "bundle exec" for each of our commands.
COPY entrypoint.sh /sbin/entrypoint.sh
ENTRYPOINT ["/sbin/entrypoint.sh"]
