#!/bin/sh

set -euo pipefail
set -x

webroot_path="/opt/acme_challenge_webroot"
ssl_path="/opt/ssl"
domains_file="/etc/domains.txt"

certbot_certs_home="/etc/letsencrypt/live"
acme_certs_home="/etc/acme"

if [ "$1" = "noop" ]; then
  echo "Do nothing: noop"
  exit 0
fi

certbot_args="";
acme_args=""
if [ "$RENEW" -eq 1 ]; then
  certbot_args="--webroot -w $webroot_path";
  acme_args="-w $webroot_path";
else
  certbot_args="--standalone";
  acme_args="--standalone";
fi

if [ "$FORCE_RENEWAL" -eq 1 ]; then
  certbot_args="$certbot_args --force-renewal"
  acme_args="$acme_args --force"
else
  certbot_args="$certbot_args --keep-until-expiring"
fi


export CERT_HOME=/etc/acme
export LE_CONFIG_HOME=/etc/acme

export PATH="${PATH}:/root/.acme.sh"


issue_rsa_cert_with_certbot(){
  local domains="$1";
  local cert_name="$2";
  local email="$3";
  local cert_src="$certbot_certs_home/$cert_name"
  local cert_dst="$4";

  certbot certonly \
    --non-interactive \
    --cert-name "$cert_name" \
    -d "$domains" \
    -m "$email" \
    --agree-tos \
    --preferred-challenges http-01 \
    --allow-subset-of-names \
    --staging \
    --rsa-key-size $RSA_KEY_LENGTH \
    $certbot_args

  cp -fL "$cert_src/cert.pem" "$cert_dst/certs/cert.rsa.pem";
  cp -fL "$cert_src/chain.pem" "$cert_dst/certs/chain.rsa.pem";
  cp -fL "$cert_src/fullchain.pem" "$cert_dst/certs/fullchain.rsa.pem";
  cp -fL "$cert_src/privkey.pem" "$cert_dst/private/privkey.rsa.pem";
}

issue_esdca_cert_with_acme(){
  local domains="$1";
  local cert_name="$2";
  local email="$3";
  local cert_src="$acme_certs_home/$cert_name"
  local cert_dst="$4";

  local issue_or_renew=$([ "$RENEW" -eq 1 ] && echo "--renew" || echo "--issue")
  local domain_args=$(echo "$domains" | awk 'BEGIN {RS=","; ORS=" "} { print "-d",$0}')
  
  set +x
  acme.sh \
    $issue_or_renew \
    $domain_args \
    --ecc \
    --keylength $ECDSA_KEY_LENGTH \
    --staging \
    $acme_args
  local issue_cert_retval=$?;
  if [ "$issue_cert_retval" -ne 2 ] && [ "$issue_cert_retval" -ne 0 ]; then
    exit $issue_cert_retval;
  fi

  set -x
 
  acme.sh \
    --install-cert -d "$cert_name" \
    --ecc \
    --cert-file "$cert_dst/certs/cert.ecc.pem" \
    --ca-file "$cert_dst/certs/chain.ecc.pem" \
    --fullchain-file "$cert_dst/certs/fullchain.ecc.pem" \
    --key-file "$cert_dst/private/privkey.ecc.pem"
}

process_domain(){
  local domains="$1";
  local common_name=${domains//,*/}
  local email="admin@$common_name";
  local cert_dst="$ssl_path/$common_name"

  # prepare location to drop certs and keys to
  mkdir -p "$cert_dst/certs" "$cert_dst/private";

  issue_esdca_cert_with_acme "$domains" "$common_name" "$email" "$cert_dst"
  issue_rsa_cert_with_certbot "$domains" "$common_name" "$email" "$cert_dst"

  # set owner and restrict permissions 
  chown -R root:ssl "$cert_dst"
  find "$cert_dst" -type d -exec chmod 755 {} +
  find "$cert_dst" -type f -exec chmod 644 {} +
  chmod -R o-rwx,g-w "$cert_dst/private"
}

main(){
  chown -R root:ssl "$ssl_path"

  while read -r domain || [[ -n "$domain" ]]; do
    process_domain "$domain"
  done < "$domains_file"
}

main






