# protocols
ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

ssl_prefer_server_ciphers on;
ssl_ciphers "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:!RSA!aNULL:!eNULL:!LOW:!RC4:!3DES:!MD5:!EXP:!PSK:!SRP:!DSS:!CAMELLIA:!SEED";

# Or use 'openssl ciphers' compatible wildcard string
# ssl_ciphers "EECDH+ECDSA+AESGCM:EECDH+aRSA+AESGCM:EECDH+ECDSA+SHA384:EECDH+ECDSA+SHA256:EECDH+aRSA+SHA384:EECDH+aRSA+SHA256:EECDH:DHE+AESGCM:DHE:!RSA!aNULL:!eNULL:!LOW:!RC4:!3DES:!MD5:!EXP:!PSK:!SRP:!DSS:!CAMELLIA:!SEED";

# RSA key exchange, no forward secrecy
# RSA+AESGCM:RSA+AES:RSA+3DES
# AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA

ssl_dhparam /etc/nginx/dhparams.pem;
ssl_ecdh_curve prime256v1:secp384r1;

# Session 
ssl_session_cache shared:SSL:10m;
ssl_session_timeout 1h;
ssl_session_tickets off;

# Enable OCSP stapling and verify it
ssl_stapling on;
ssl_stapling_verify on;

# In Docker container we have embedded DNS server at 127.0.0.11
# Specify resolvers so OCSP stapling request can resolve OCSP servers
resolver 127.0.0.11 valid=300s ipv6=off;
resolver_timeout 5s;

# Enable HSTS
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

# enable incl. subdomains
# add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

# disable HSTS
# add_header Strict-Transport-Security "max-age=0" always;


# Prevent website to be displayed in <iframe> or <object>
add_header X-Frame-Options DENY;
# add_header X-Frame-Options SAMEORIGIN;

# add_header X-Content-Type-Options nosniff;
# add_header X-XSS-Protection "1; mode=block";
# add_header X-Robots-Tag none;