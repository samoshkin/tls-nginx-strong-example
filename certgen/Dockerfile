FROM certbot/certbot

ARG SSL_GROUP_GID=1337

ENV RENEW=0
ENV FORCE_RENEWAL=0
ENV RSA_KEY_LENGTH=2048
ENV ECDSA_KEY_LENGTH=ec-256

# Install acme.sh client
RUN apk add --update curl openssl socat \
  && curl -s https://get.acme.sh | sh \
  && rm -rf /var/cache/apk/* \
# Create "ssl" group with given GID
  && addgroup -S -g $SSL_GROUP_GID ssl

COPY entrypoint.sh /usr/local/bin
COPY domains.txt /etc/

VOLUME /opt/acme_challenge_webroot
VOLUME /etc/letsencrypt
VOLUME /etc/acme
VOLUME /opt/ssl

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
