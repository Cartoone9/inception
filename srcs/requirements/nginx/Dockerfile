# --- SSL Certificate generation --- #

FROM debian@sha256:e899040a73d36e2b36fa33216943539d9957cba8172b858097c2cabcdb20a3e2 AS cert-maker
# debian bookworm slim ver12.12 

RUN apt-get update && apt-get install -y openssl \
	&& mkdir -p /etc/nginx/ssl \
	&& openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=user.42.fr"


# --- Nginx container setup --- #

FROM debian@sha256:e899040a73d36e2b36fa33216943539d9957cba8172b858097c2cabcdb20a3e2
# debian bookworm slim ver12.12 

RUN apt-get update && apt-get install --no-install-recommends -y nginx \
    && apt-get clean \
	&& rm -rf /var/lib/apt/lists/* # cleans the package & install scripts
								   # then delete the apt cache to save space

# Forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir -p /var/www/wordpress \
	&& chmod -R 755 /var/www/wordpress \
	&& chown -R www-data:www-data /var/www/wordpress

#WORKDIR /var/www/wordpress

RUN mkdir -p /etc/nginx/ssl

COPY --from=cert-maker /etc/nginx/ssl/inception.crt /etc/nginx/ssl/inception.crt
COPY --from=cert-maker /etc/nginx/ssl/inception.key /etc/nginx/ssl/inception.key

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/nginx_script.sh /nginx_script.sh
RUN chmod +x /nginx_script.sh

EXPOSE 443

CMD ["/nginx_script.sh"]
