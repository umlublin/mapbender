FROM debian:buster-slim

RUN apt-get update && apt-get install -y locales php php-cli openssl bzip2 \
    php-curl php-gd php-intl php-mbstring php-zip php-bz2 php-xml php-json \
    php-sqlite3 php-pgsql php-mysql php-ldap sqlite3 curl && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# Change back to the "node" user; using its UID for PodSecurityPolicy "non-root" compatibility
USER 1000
CMD ["cat", "-"]
