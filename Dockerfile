FROM haproxy:2.2
LABEL maintainer="Jack Liou <jack@click-ap.com>"

# Install package
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install software-properties-common rsyslog supervisor php-cli php-curl nginx curl git

RUN curl -s http://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    mkdir -p /usr/share/hle && \
    cd /usr/share/hle && \
    composer require fbett/le_acme2 && \
    mkdir /etc/ssl/le-storage/ && \
    chown root:root /etc/ssl/le-storage && \
    chmod 0600 /etc/ssl/le-storage && \
    mkdir /etc/hle && \
    mkdir -p /var/www/letsencrypt && \
    chown www-data:www-data -R /var/www/letsencrypt && \
    cp -r /usr/local/etc/haproxy /etc/haproxy

# Remove cache and package
# Clear APT cache
RUN apt-get remove --purge -y git curl && rm -rf /usr/local/bin/composer
RUN apt-get remove --purge -y software-properties-common && \
    apt-get autoremove -y && \
    apt-get clean && \
    apt-get autoclean && \
    echo -n > /var/lib/apt/extended_states && \
    rm -rf /usr/share/man/?? && \
    rm -rf /usr/share/man/??_* && \
    rm -rf /var/cache/apk/*

# Setup configuration files
ADD nginx.conf             /etc/nginx/nginx.conf
ADD ssl.pem                /etc/haproxy/ssl.pem
ADD haproxy.cfg            /etc/haproxy/haproxy.cfg
ADD haproxy.cfg            /etc/haproxy/haproxy.cfg.init
ADD sv-haproxy.conf        /etc/supervisor/conf.d
ADD sv-nginx.conf          /etc/supervisor/conf.d
ADD sv-renew.conf          /etc/supervisor/conf.d
ADD letsencrypt            /etc/nginx/sites-enabled
ADD default                /etc/nginx/sites-enabled
ADD hle-renew.php          /usr/share/hle
ADD renew-service.sh       /usr/share/hle
ADD haproxy.cfg.php        /usr/share/hle
ADD entrypoint.sh          /entrypoint.sh

RUN chmod +x /usr/share/hle/renew-service.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
