#!/usr/bin/env bash

set -eux

PREFIX="${PROJECT_NAME}_";

docker run \
  -v ${PREFIX}ssl:/opt/ssl \
  -v ${PREFIX}acme_challenge_webroot:/opt/acme_challenge_webroot \
  -v ${PREFIX}letsencrypt:/etc/letsencrypt \
  -e RENEW=1 \
  --rm \
  ${PREFIX}certbot
