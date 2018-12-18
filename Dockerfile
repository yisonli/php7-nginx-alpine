FROM alpine:latest

RUN apk update
RUN apk add php7 nginx
RUN apk add curl bash
RUN apk add php7-mysqli php7-pdo_mysql php7-mbstring php7-json php7-zlib php7-gd php7-intl php7-session php7-fpm php7-memcached php7-curl php7-posix php7-fileinfo php7-simplexml

RUN mkdir /run/nginx
RUN touch /run/nginx/nginx.pid

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY run.sh /run.sh
COPY index.php /var/www/index.php

# 若使用root权限启动php, 需修改配置如下
RUN sed 's/user = nobody/user = root/g' /etc/php7/php-fpm.d/www.conf | sed 's/group = nobody/group = root/g' > /tmp/www.conf
RUN mv /tmp/www.conf /etc/php7/php-fpm.d/www.conf

CMD ["/run.sh"]

