FROM debian@sha256:e899040a73d36e2b36fa33216943539d9957cba8172b858097c2cabcdb20a3e2
# debian bookworm slim ver12.12 

RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
    cron \
    mariadb-client \
	procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY tools/backup_script.sh /backup_script.sh
COPY tools/backup_crontab /etc/cron.d/backup_crontab

RUN chmod +x /backup_script.sh
RUN chmod 644 /etc/cron.d/backup_crontab

CMD ["cron", "-f"]
