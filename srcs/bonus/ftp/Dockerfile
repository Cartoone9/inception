FROM debian@sha256:e899040a73d36e2b36fa33216943539d9957cba8172b858097c2cabcdb20a3e2
# debian bookworm slim ver12.12 

RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
	vsftpd \
	netcat-openbsd \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY conf/vsftpd.conf /etc/vsftpd.conf
RUN chmod 600 /etc/vsftpd.conf

COPY tools/ftp_script.sh /ftp_script.sh
RUN chmod +x /ftp_script.sh

EXPOSE 21
EXPOSE 21100:21150

CMD ["/ftp_script.sh"]
