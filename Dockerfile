FROM debian:jessie
MAINTAINER Gabriel Wicke <gwicke@wikimedia.org>

# Waiting in antiticipation for built-time arguments
# https://github.com/docker/docker/issues/14634
ENV MEDIAWIKI_VERSION 1.27.1

# XXX: Consider switching to nginx.
RUN set -x; \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        apache2 \
        libapache2-mod-php5 \
        php5-mysql \
        php5-cli \
        php5-gd \
        php5-curl \
        imagemagick \
        netcat \
        git \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/archives/* \
    && a2enmod rewrite \
    && a2enmod proxy \
    && a2enmod proxy_http \
    # Remove the default Debian index page.
    && rm /var/www/html/index.html


# MediaWiki setup
RUN set -x; \
    mkdir -p /usr/src \
    && git clone \
        --depth 1 \
        -b wmf/1.29.0-wmf.18 \
        https://gerrit.wikimedia.org/r/p/mediawiki/core.git \
        /usr/src/mediawiki 

RUN set -x; cd /usr/src/mediawiki \
    && git checkout wmf/1.29.0-wmf.18 \
    && git submodule update --init skins \
    && git submodule update --init vendor \
    && cd extensions \
    # VisualEditor
    # TODO: make submodules shallow clones?
    && git submodule update --init VisualEditor \
    && cd VisualEditor \
    && git submodule update --init

COPY php.ini /usr/local/etc/php/conf.d/mediawiki.ini

COPY apache/mediawiki.conf /etc/apache2/
RUN echo "Include /etc/apache2/mediawiki.conf" >> /etc/apache2/apache2.conf

COPY docker-entrypoint.sh /entrypoint.sh
RUN sed -i 's/\*:80/\*:1080/' /etc/apache2/sites-enabled/000-default.conf && \
	sed -i 's/\*:80/\*:1080/' /etc/apache2/sites-available/000-default.conf

EXPOSE 1080 10443
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apachectl", "-e", "info", "-D", "FOREGROUND"]
