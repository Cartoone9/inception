FROM debian@sha256:e899040a73d36e2b36fa33216943539d9957cba8172b858097c2cabcdb20a3e2
# debian bookworm slim ver12.12 

RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
	php8.2 \
	php8.2-fpm \
	php8.2-mysql \
	php8.2-mbstring \
	php8.2-zip \
	php8.2-gd \
	php8.2-curl \
	php8.2-xml \
	php8.2-redis \
    ca-certificates \
	curl \
	netcat-openbsd \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

RUN mkdir -p /var/www/wordpress \
	&& chmod -R 755 /var/www/wordpress \
	&& chown -R www-data:www-data /var/www/wordpress

COPY tools/wp_script.sh /wp_script.sh
RUN chmod +x wp_script.sh

CMD ["/wp_script.sh"]
