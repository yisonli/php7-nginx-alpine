FROM alpine:latest

RUN apk update
RUN apk add php7 nginx
RUN apk add curl bash
RUN apk add php7-mysqli php7-pdo_mysql php7-mbstring php7-json php7-zlib php7-gd php7-intl php7-session php7-fpm php7-memcached php7-curl php7-posix php7-fileinfo php7-simplexml php7-opcache
RUN apk add php7-tokenizer php7-ctype php7-bcmath php7-openssl php7-dom php7-iconv php7-zip php7-pcntl
RUN apk add supervisor

RUN mkdir /run/nginx
RUN touch /run/nginx/nginx.pid

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY run.sh /run.sh
COPY index.php /var/www/index.php

# 若使用root权限启动php, 修改最大子进程数且一次性分配, 需修改配置如下
RUN sed 's/user = nobody/user = root/g' /etc/php7/php-fpm.d/www.conf | sed 's/group = nobody/group = root/g' | sed 's/pm.max_children = 5/pm.max_children = 30/g' | sed 's/pm = dynamic/pm = static/g' > /tmp/www.conf
RUN mv /tmp/www.conf /etc/php7/php-fpm.d/www.conf

# 若使用root权限启动nginx, 开启gzip压缩, 需修改配置如下
RUN sed 's/user nginx;/user root;/g' /etc/nginx/nginx.conf | sed 's/#gzip on;/gzip on;/g' > /tmp/nginx.conf
RUN mv /tmp/nginx.conf /etc/nginx/nginx.conf

# 开启opcache
RUN sed 's/;opcache.enable=1/opcache.enable=1/g' /etc/php7/php.ini | sed 's/;opcache.validate_timestamps=1/opcache.validate_timestamps=0/g' | sed 's/;opcache.memory_consumption=128/opcache.memory_consumption=128/g' | sed 's/;opcache.interned_strings_buffer=8/opcache.interned_strings_buffer=8/g' | sed 's/;opcache.max_accelerated_files=10000/opcache.max_accelerated_files=10000/g' > /tmp/php.ini
RUN mv /tmp/php.ini /etc/php7/php.ini

# Supervisor 的相关配置
RUN mkdir -p /etc/supervisor.d
COPY supervisor_default.ini /etc/supervisor.d/supervisor_default.ini


CMD ["/run.sh"]

