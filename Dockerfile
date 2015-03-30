FROM phusion/baseimage:latest

MAINTAINER Christian Lück <christian@lueck.tv>

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Install NGINX
ENV DEBIAN_FRONTEND noninteractive
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update
RUN apt-get install -y \
	nginx \
	nginx-extras \
	php5-cli \
	apache2-utils 

# Cleanup
RUN apt-get clean 
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add passwordfile, create new users with:
# touch htpasswd;htpasswd -B -b htpasswd konijn $(echo pw4konijn)
ADD htpasswd /htpasswd

# Add script to create configs from the Docker environment variables
RUN rm /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
ADD apply-from-env.php apply-from-env.php
RUN mkdir /etc/service/apply-from-env
ADD scripts/apply-from-env.sh /etc/service/apply-from-env/run
RUN chmod +x /etc/service/apply-from-env/run

# Add NGINX to baseimage-docker's init system.

# Append "daemon off;" to the configuration
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN mkdir /etc/service/nginx
ADD scripts/nginx.sh /etc/service/nginx/run
RUN chmod +x /etc/service/nginx/run

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

EXPOSE 80
