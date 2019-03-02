from nginx:latest

ENV CLIENT_ID d6b3e234-d9dc-454e-bc42-9f74ea701b7d
ENV CLIENT_ALTERID 4
ENV CLIENT_SECURITY aes-128-cfb

ADD conf/nginx.conf /etc/nginx/
ADD conf/default.conf /etc/nginx/conf.d/
ADD v2ray /usr/local/bin/
ADD v2ctl /usr/local/bin/
ADD geoip.dat /usr/local/bin/
ADD geosite.dat /usr/local/bin/
ADD entrypoint.sh /etc/

RUN apt-get update \
	&& apt-get install -y --no-install-recommends php-fpm php-curl php-cli php-mcrypt php-mysql php-readline \
	&& chmod -R 777 /var/log/nginx /var/cache/nginx /var/run \
	&& chgrp -R 0 /etc/nginx \
	&& chmod -R g+rwx /etc/nginx \
	&& mkdir /run/php/ \
	&& chmod -R 777 /var/log/ /run/php/ \
	&& mkdir /var/log/v2ray \
	&& mkdir /etc/v2ray \
	&& chmod 777 /usr/local/bin/v2ray \
	&& chmod 777 /usr/local/bin/v2ctl \
	&& chmod 777 /usr/local/bin/geoip.dat \
	&& chmod 777 /usr/local/bin/geosite.dat \
	&& chmod -R 777 /var/log/v2ray \
	&& chmod -R 777 /etc/v2ray \
	&& chmod 777 /etc/entrypoint.sh \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /var/cache/apt/*

ADD conf/config.json /etc/v2ray/
ADD conf/www.conf /etc/php/7.0/fpm/pool.d/
ADD src/tz.php /usr/share/nginx/html/
ADD html /usr/share/nginx/html

EXPOSE 8080
ENTRYPOINT ["/etc/entrypoint.sh"]
