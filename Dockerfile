FROM debian:buster-slim

RUN apt-get update && apt-get install -y locales git php php-cli openssl bzip2 \
    php-curl php-gd php-intl php-mbstring php-zip php-bz2 php-xml php-json \
    php-sqlite3 php-pgsql php-mysql php-ldap sqlite3 curl && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN git clone https://github.com/mapbender/mapbender-starter.git /mapbender
RUN cd /mapbender/application && php bin/composer install -o --no-scripts --no-suggest
RUN chmod a+x /mapbender/application/vendor/wheregroup/sassc-binaries/dist/sassc
RUN cd /mapbender/application && \
php bin/composer run build-bootstrap && \
php bin/composer init-example && \
php app/console assets:install --symlink --relative && \
php app/console mapbender:database:init -v && \
php bin/composer run post-autoload-dump

RUN chmod a+rwx /mapbender/application/app/logs && rm /mapbender/application/app/logs/dev.log

# Change back to the "node" user; using its UID for PodSecurityPolicy "non-root" compatibility
#echo ' cd application'
#echo ' php app/console server:run'
USER 1000
CMD ["php /mapbender/application/app/console", "server:run"]

