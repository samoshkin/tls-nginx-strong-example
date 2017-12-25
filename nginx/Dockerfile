FROM nginx:alpine

ARG SSL_GROUP_GID=1337

RUN echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories \
  && apk --no-cache add shadow openssl \
  && addgroup -S -g $SSL_GROUP_GID ssl \
  && usermod -aG ssl nginx

RUN rm -rf /etc/nginx/conf.d \
  && openssl dhparam -dsaparam -out /etc/nginx/dhparams.pem 4096

COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d /etc/nginx/conf.d
COPY entrypoint.sh /usr/local/bin

VOLUME /etc/nginx/ssl
VOLUME /var/www/acme_challenge_webroot

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
