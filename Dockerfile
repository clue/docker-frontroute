FROM ubuntu
MAINTAINER Christian Lück <christian@lueck.tv>

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
	nginx php5-cli

RUN rm /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

ADD apply-from-env.php apply-from-env.php
CMD ./apply-from-env.php && /usr/sbin/nginx -g "daemon off;"

EXPOSE 80

