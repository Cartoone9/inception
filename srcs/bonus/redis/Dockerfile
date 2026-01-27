FROM debian@sha256:e899040a73d36e2b36fa33216943539d9957cba8172b858097c2cabcdb20a3e2
# debian bookworm slim ver12.12 

RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
	redis-server \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY conf/redis.conf /etc/redis/redis.conf
COPY tools/redis_script.sh /redis_script.sh
RUN chmod +x /redis_script.sh

CMD ["/redis_script.sh"]
