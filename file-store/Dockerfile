FROM openmandriva/openmandriva2014.0
MAINTAINER alexander@mezon.ru

ENV RUBY ruby-2.2.3

RUN urpmi --auto --auto-update --no-verify-rpm \
    && urpmi.addmedia contrib_release http://abf-downloads.openmandriva.org/openmandriva2014.0/repository/x86_64/contrib/release \
    && urpmi.addmedia contrib_updates http://abf-downloads.openmandriva.org/openmandriva2014.0/repository/x86_64/contrib/updates \
    && urpmi.update -a \
    && urpmi --no-suggests --no-verify-rpm glusterfs-client sysvinit-tools gnupg curl attr nodejs \
	git postgresql-devel yaml-devel gcc-c++ readline-devel icu-devel cmake openssl-devel libtool bison \
    && curl -sSL https://rvm.io/mpapis.asc | gpg2 --import - \
    && /bin/bash -l -c "curl -L get.rvm.io | bash -s stable" \
    && export PATH=$PATH:/usr/local/rvm/bin/ \
    && /bin/bash -l -c "source /usr/local/rvm/scripts/rvm" \
    && /bin/bash -l -c "rvm install $RUBY" \
    && /bin/bash -l -c "rvm use $RUBY"

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
WORKDIR /app

# Configure an entry point, so we don't need to specify
# "bundle exec" for each of our commands.
COPY entrypoint.sh /sbin/entrypoint.sh
ENTRYPOINT ["/sbin/entrypoint.sh"]
