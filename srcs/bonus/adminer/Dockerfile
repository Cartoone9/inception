FROM debian@sha256:e899040a73d36e2b36fa33216943539d9957cba8172b858097c2cabcdb20a3e2
# debian bookworm slim ver12.12 

RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
	php8.2 \
	php8.2-fpm \
	php8.2-mysql \
    ca-certificates \
    curl \
	netcat-openbsd \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/adminer \
	&& curl -L https://github.com/vrana/adminer/releases/download/v5.4.1/adminer-5.4.1.php \
    -o /var/www/adminer/index.php

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

CMD ["php-fpm8.2", "-F"]
