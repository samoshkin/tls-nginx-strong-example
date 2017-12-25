# protocols
ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

ssl_prefer_server_ciphers on;
# TODO: easy to enumerate manually
ssl_ciphers "EECDH+ECDSA+AESGCM:EECDH+aRSA+AESGCM:EECDH+ECDSA+SHA384:EECDH+ECDSA+SHA256:EECDH+aRSA+SHA384:EECDH+aRSA+SHA256:EECDH:DHE+AESGCM:DHE:!aNULL:!eNULL:!LOW:!RC4:!3DES:!MD5:!EXP:!PSK:!SRP:!DSS:!CAMELLIA:!SEED";
# RSA+AESGCM:RSA+AES:RSA+3DES

ssl_dhparam /etc/nginx/dhparams.pem;
ssl_ecdh_curve prime256v1:secp384r1;

# Session 
ssl_session_cache shared:SSL:10m;
ssl_session_timeout 1h;
ssl_session_tickets off;

# allow Nginx to send OCSP results during the connection process
ssl_stapling on;
ssl_stapling_verify on;

# Enable HSTS
add_header Strict-Transport-Security "max-age=31536000" always;
# add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

# Prevent website to be displayed in <iframe> or <object>
add_header X-Frame-Options DENY;
# add_header X-Frame-Options SAMEORIGIN;

# add_header X-Content-Type-Options nosniff;
# add_header X-XSS-Protection "1; mode=block";
# add_header X-Robots-Tag none;