FROM php:7.2-apache

#https://www.mediawiki.org/wiki/Manual:Running_MediaWiki_on_Red_Hat_Linux
#As per above doc, mediawiki is installed under /var/www/mediawiki, so configure apache for the same.

#Refer 'https://hub.docker.com/_/php' to install php plugins, change apache configurations etc

ENV APACHE_DOCUMENT_ROOT /var/www/mediawiki

RUN mkdir -p /var/www/mediawiki
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf


# Install the PHP extensions we need
RUN set -eux; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libicu-dev \
	; \
	\
	docker-php-ext-install -j "$(nproc)" \
		intl \
		mbstring \
		mysqli \
		opcache 


# Download and extract application tarball
WORKDIR /var/www/mediawiki
ENV MEDIAWIKI_MAJOR_VERSION 1.33
ENV MEDIAWIKI_BRANCH REL1_33
ENV MEDIAWIKI_VERSION 1.33.0
ENV MEDIAWIKI_SHA512 e31f5d8bd0bef39b9e2db71f129da128d20174f86e6a4799de5e24195bdcbbc06778b978a48073934b6e59d837629d6b83c182c8271b5fb944ef4ce5df856c68

# MediaWiki setup
RUN set -eux; \
	curl -fSL "https://releases.wikimedia.org/mediawiki/${MEDIAWIKI_MAJOR_VERSION}/mediawiki-${MEDIAWIKI_VERSION}.tar.gz" -o mediawiki.tar.gz; \
	echo "${MEDIAWIKI_SHA512} *mediawiki.tar.gz" | sha512sum -c -; \
	tar -x --strip-components=1 -f mediawiki.tar.gz; \
	rm mediawiki.tar.gz; \
	chown -R www-data:www-data extensions skins cache images

