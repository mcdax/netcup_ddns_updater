FROM alpine:latest
LABEL maintainer="mcdax"

# Add basics first
RUN apk update && apk upgrade
RUN apk --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing add \
    bash \
    apache2 \
    openssl \
    php-apache2 \
    ca-certificates \
    php \
    php-soap \
    php-mbstring \
    php-curl \
    php-json \
    php-simplexml \
    php-openssl \
    tzdata

RUN rm -f /var/cache/apk/*

# Add apache to run and configure
RUN  sed -i "s/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ session_module/LoadModule\ session_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ session_cookie_module/LoadModule\ session_cookie_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ session_crypto_module/LoadModule\ session_crypto_module/" /etc/apache2/httpd.conf \
    && sed -i "s/#LoadModule\ deflate_module/LoadModule\ deflate_module/" /etc/apache2/httpd.conf \
    && sed -i "s#^DocumentRoot \".*#DocumentRoot \"/app/public\"#g" /etc/apache2/httpd.conf \
    && sed -i "s#/var/www/localhost/htdocs#/app/public#" /etc/apache2/httpd.conf \
    && sed -i -r 's@Errorlog .*@Errorlog /dev/stderr@i' /etc/apache2/httpd.conf \
    && printf "\n<Directory \"/app/public\">\n\tAllowOverride All\n</Directory>\n" >> /etc/apache2/httpd.conf

# Pin ownDynDNS so the local patches apply reliably
ARG OWNDYNDNS_COMMIT=d756c8a80a060879dae8615d9d3ec2c6125f0027
ADD patches /bootstrap/patches
RUN apk add --no-cache git && \
    mkdir /app && mkdir /app/public && chown -R apache:apache /app && chmod -R 755 /app && mkdir -p bootstrap && \
    git clone https://github.com/fernwerker/ownDynDNS /app/vendor/owndyndns && \
    git -C /app/vendor/owndyndns checkout -q $OWNDYNDNS_COMMIT && \
    git -C /app/vendor/owndyndns apply /bootstrap/patches/*.patch
ADD start.sh /bootstrap/
RUN chmod +x /bootstrap/start.sh

EXPOSE 80
ENTRYPOINT ["/bootstrap/start.sh"]
