FROM openmandriva/3.0
MAINTAINER alexander@mezon.ru

ENV RUBY ruby-2.4.1

RUN urpmi --auto --auto-update --no-verify-rpm \
    && urpmi.addmedia contrib_release http://abf-downloads.openmandriva.org/3.0/repository/x86_64/contrib/release \
    && urpmi.addmedia contrib_updates http://abf-downloads.openmandriva.org/3.0/repository/x86_64/contrib/updates \
    && urpmi.update -a \
    && urpmi --no-suggests --no-verify-rpm --auto nodejs icu-devel git cmake postgresql-devel procps-ng gnutar curl wget pkgconfig \
    && curl -sSL https://rvm.io/mpapis.asc | gpg --import - \
    && /bin/bash -l -c "curl -L get.rvm.io | bash -s stable" \
    && export PATH=$PATH:/usr/local/rvm/bin/ \
    && /bin/bash -l -c "source /usr/local/rvm/scripts/rvm" \
    && /bin/bash -l -c "rvm install $RUBY" \
    && /bin/bash -l -c "rvm use $RUBY" \
    && rm -rf /usr/share/man/ /usr/share/cracklib /usr/share/doc /var/lib/rpm /usr/share/locale

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
WORKDIR /app

# Configure an entry point, so we don't need to specify
# "bundle exec" for each of our commands.
COPY entrypoint.sh /sbin/entrypoint.sh
ENTRYPOINT ["/sbin/entrypoint.sh"]
