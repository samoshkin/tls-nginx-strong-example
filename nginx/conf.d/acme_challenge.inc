# access to the letsencrypt ACME challenge
location ^~ /.well-known/acme-challenge {
  allow all;
  root /var/www/acme_challenge_webroot;
  default_type text/plain;
}