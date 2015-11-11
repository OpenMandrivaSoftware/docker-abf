FROM ruby:2.2
MAINTAINER avokhmin@gmail.com

# Install apt based dependencies required to run Rails as
# well as RubyGems. As the Ruby image itself is based on a
# Debian image, we use apt-get to install those.
RUN apt-get update \
   && DEBIAN_FRONTEND=noninteractive \
   && apt-get install -y build-essential nodejs git cmake apt-utils libicu-dev rpm \
   && chown -R root:staff /usr/local/lib/ruby/ \
   && chmod -R g+rwx /usr/local/

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
