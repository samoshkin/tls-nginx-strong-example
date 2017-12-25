#!/bin/sh

set -euo pipefail
set -x

RENEW=${RENEW:-0}
FORCE_RENEWAL=${FORCE_RENEWAL:-0}

webroot_path="/opt/acme_challenge_webroot"
ssl_path="/opt/ssl"
domains_file="/etc/domains.txt"

certbot_args="";
if [ "$RENEW" -eq 1 ]; then
  certbot_args="--webroot -w $webroot_path";
else
  certbot_args="--standalone";
fi

if [ "$FORCE_RENEWAL" -eq 1 ]; then
  certbot_args="$certbot_args --force-renewal"
else
  certbot_args="$certbot_args --keep-until-expiring"
fi

chown -R root:ssl "$ssl_path"

issue_or_renew_certificate() {
  local domains="$1";
  # use first domain (Common name) for cert name
  local cert_name=${domains//,*/}
  local email="admin@$cert_name";
  local cert_src="/etc/letsencrypt/live/$cert_name"
  local cert_dst="$ssl_path/$cert_name"

  certbot certonly \
    --non-interactive \
    --cert-name "$cert_name" \
    -d "$domains" \
    -m "$email" \
    --agree-tos \
    --preferred-challenges http-01 \
    --allow-subset-of-names \
    --staging \
    $certbot_args

  mkdir -p "$cert_dst/certs" "$cert_dst/private";

  cp -fL "$cert_src/cert.pem" "$cert_dst/certs/";
  cp -fL "$cert_src/chain.pem" "$cert_dst/certs/";
  cp -fL "$cert_src/fullchain.pem" "$cert_dst/certs/";

  cp -fL "$cert_src/privkey.pem" "$cert_dst/private/";

  chmod -R u+rwX,go+rX,go-w "$cert_dst"
  chmod -R ug+rX,o-rwx,a-w "$cert_dst/private"
  chown -R root:ssl "$cert_dst"
}

while read -r domain || [[ -n "$domain" ]]; do
  issue_or_renew_certificate "$domain"
done < "$domains_file"



