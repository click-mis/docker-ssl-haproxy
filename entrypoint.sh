#!/bin/bash

# ACME directory
if [ ! -d "/var/www/letsencrypt/.well-known/acme-challenge" ]; then
  mkdir -p "/var/www/letsencrypt/.well-known/acme-challenge"
fi
chown www-data:www-data -R /var/www/letsencrypt
chown www-data:www-data -R /var/www/html

if [ ! -d "/etc/hle/pem" ]; then
  mkdir -p "/etc/hle/pem"
fi

cp /etc/haproxy/haproxy.cfg.init /etc/haproxy/haproxy.cfg

sed -i 's/\[unix_http_server\]/&\npassword=dummy/' /etc/supervisor/supervisord.conf
sed -i 's/\[unix_http_server\]/&\nusername=dummy/' /etc/supervisor/supervisord.conf

sed -i 's/\[supervisorctl\]/&\npassword=dummy/' /etc/supervisor/supervisord.conf
sed -i 's/\[supervisorctl\]/&\nusername=dummy/' /etc/supervisor/supervisord.conf

sed -i 's/\[supervisord\]/&\nuser=root/' /etc/supervisor/supervisord.conf

# Supervisord start
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
