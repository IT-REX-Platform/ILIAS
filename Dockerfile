# Start with a Ubuntu 20.04 (LTS).
FROM ubuntu:20.04

# Set and export the timezone so we don't break the build.
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Setup for ILIAS based on: https://docu.ilias.de/goto_docu_pg_116903_367.html
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && apt-get install -y \
    wget \
    zip \
    unzip \
    git \
    apache2 \
    libapache2-mod-php7.4 \
    php7.4 \
    php7.4-curl \
    php7.4-gd \
    php7.4-mysql \
    php7.4-mbstring \
    php-xml \
    php7.4-xsl \
    htmldoc \
    imagemagick \
    ffmpeg \
    sendmail \
# For mysql:
    mysql-client \
# For postgresql:
    postgresql-client
# If Java should be used, use this:
#	openjdk-8-jdk

# Set /data as the main working directory and add the external resources folder.
WORKDIR /data
ADD resources /data/resources

# TODO: This should be the section where php settings are getting replaced.
# The updated/modified settings are found in the resources/phpinisettings file.
# Not sure whether this is necessary for us, but if it is, do that here.

# Make a share folder as a temp folder for the server.
RUN mkdir /data/share \
&& chown www-data:www-data /data/share \
&& chmod 751 /data/share \
# Let the entry point be executable.
&& chown www-data:www-data /data/resources/entrypoint.sh \
&& chmod 751 /data/resources/entrypoint.sh \
# Let the scripts be executable which create and restore dumps.
&& chown www-data:www-data /data/resources/createiliasdump.sh \
&& chmod 751 /data/resources/createiliasdump.sh \
&& chown www-data:www-data /data/resources/restoreilias.sh \
&& chmod 751 /data/resources/restoreilias.sh \
# Keeping that from the base, just in case:
# Problem in LetsEncrypt when changing the DocumentRoot...
# && sed -i 's|/var/www/html|/var/www/html/ilias|g' /etc/apache2/sites-enabled/000-default.conf \
# ...so we do a http redirect to /ilias
&& rm /var/www/html/index.html \
&& echo "<?php header('Location: ilias'); ?>" > /var/www/html/index.php

ENV apachestartmode="FOREGROUND"

# EXPOSE 80 443 # This shouldn't be needed to expose the ports.
ENTRYPOINT ["/data/resources/entrypoint.sh"]
