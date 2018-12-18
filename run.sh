#!/bin/sh


# Start php and nginx 
while :
do
  runningPHP=$(ps -ef |grep "php-fpm" |grep -v "grep" | wc -l)
  if [ "$runningPHP" -eq 0 ] ; then
    echo "PHP service was not started. Startting now." 
    /usr/sbin/php-fpm7 -R
  fi

  runningNginx=$(ps -ef |grep "nginx" |grep -v "grep" | wc -l)
  if [ "$runningNginx" -eq 0 ] ; then
    echo "Nginx service was not started. Startting now." 
    /usr/sbin/nginx
  fi

  sleep 60
done
