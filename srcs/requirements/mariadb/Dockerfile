FROM debian@sha256:e899040a73d36e2b36fa33216943539d9957cba8172b858097c2cabcdb20a3e2
# debian bookworm slim ver12.12 

RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
	mariadb-server \
    mariadb-client \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY tools/mariadb_script.sh /mariadb_script.sh

RUN chmod +x /mariadb_script.sh

CMD ["/mariadb_script.sh"]
