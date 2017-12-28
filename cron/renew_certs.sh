#!/usr/bin/env bash

set -eux

# Since we start our services using docker compose, 
# volume, images and containers are prefixed with COMPOSE_PROJECT_NAME
DOCKER_PREFIX="${PROJECT_NAME}_";

# Run 'asamoshkin/letsencrypt-certgen' image to renew certificates
docker run \
  -v ${DOCKER_PREFIX}ssl:/var/ssl \
  -v ${DOCKER_PREFIX}acme_challenge_webroot:/var/acme_challenge_webroot \
  -v ${DOCKER_PREFIX}letsencrypt:/etc/letsencrypt \
  -v ${DOCKER_PREFIX}acme:/etc/acme \
  -e CHALLENGE_MODE=webroot \
  -e SSL_GROUP_ID \
  -e RSA_KEY_LENGTH \
  -e ECDSA_KEY_LENGTH \
  -e DOMAINS \
  -e STAGING \
  -e VERBOSE \
  --rm \
  asamoshkin/letsencrypt-certgen:v0.1.1 renew

# reload nginx once certificates are renewed
nginx_container_id=$(docker ps -q -f name="${DOCKER_PREFIX}nginx_*" | head -n 1)
if [ -n "$nginx_container_id" ]; then
  docker kill -s HUP "$nginx_container_id"
fi
