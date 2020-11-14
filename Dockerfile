FROM alpine
MAINTAINER Guilherme Amorim <guiamorim91@gmail.com>

ENV TIMEZONE America/Sao_Paulo
RUN apk --update add openrc \ 
             tzdata \
             wget \
             curl \
             git \
             apache2 \
             php7 \
             php7-apache2 \
             php7-curl \
             php7-openssl \
             php7-iconv \
             php7-bcmath \
             php7-ctype \
             php7-pdo \
             php7-pdo_pgsql \
             php7-xml \
             php7-xmlwriter \
             php7-fileinfo \
             php7-json \
             php7-session \
             php7-tokenizer \
             php7-mbstring \
             php7-xdebug \
             php7-phar \
             php7-dom --repository http://nl.alpinelinux.org/alpine/edge/testing/ && rm /var/cache/apk/*

RUN cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" > /etc/timezone

WORKDIR /var/www/localhost/htdocs
RUN mkdir -p /var/www/localhost/htdocs/public
ENV APACHE_DOCUMENT_ROOT /var/www/localhost/htdocs/public

RUN sed -i '/LoadModule rewrite_module/s/^#//g' /etc/apache2/httpd.conf \
    && sed -i '/LoadModule session_module/s/^#//g' /etc/apache2/httpd.conf \
    && sed -ri -e 's!/var/www/localhost/htdocs!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/httpd.conf \
    && sed -i 's/AllowOverride\ None/AllowOverride\ All/g' /etc/apache2/httpd.conf \
    && sed -i 's#AllowOverride [Nn]one#AllowOverride All#' /etc/apache2/httpd.conf

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]