FROM debian@sha256:e899040a73d36e2b36fa33216943539d9957cba8172b858097c2cabcdb20a3e2
# debian bookworm slim ver12.12 

COPY ./index.html /var/www/static/index.html
COPY ./ressources/ /var/www/static/ressources/

RUN chmod -R 755 /var/www/static \
	&& chown -R www-data:www-data /var/www/static
