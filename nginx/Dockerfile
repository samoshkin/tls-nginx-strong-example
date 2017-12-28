FROM nginx:alpine

ARG SSL_GROUP_GID=1337

# Create a dedicated 'ssl' group, that have access to certificates and private keys
# add 'nginx' user to 'ssl' group
RUN echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories \
  && apk --no-cache add shadow openssl \
  && addgroup -S -g $SSL_GROUP_GID ssl \
  && usermod -aG ssl nginx

# Generate DH params
# Note, that better to do this out of container on a machine with enough random data
RUN rm -rf /etc/nginx/conf.d \
  && openssl dhparam -dsaparam -out /etc/nginx/dhparams.pem 4096

COPY entrypoint.sh /usr/local/bin

# Copy nginx config files
COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.d /etc/nginx/conf.d

VOLUME /etc/nginx/ssl
VOLUME /var/www/acme_challenge_webroot

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
