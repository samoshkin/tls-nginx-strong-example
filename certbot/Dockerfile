FROM certbot/certbot

ARG SSL_GROUP_GID=1337
ENV RENEW=0
ENV FORCE_RENEWAL=0

RUN addgroup -S -g $SSL_GROUP_GID ssl

COPY certbot.sh /usr/local/bin
COPY domains.txt /etc/

VOLUME /opt/acme_challenge_webroot
VOLUME /etc/letsencrypt
VOLUME /opt/ssl

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/certbot.sh"]
