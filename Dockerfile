FROM phusion/baseimage:latest

MAINTAINER Jaekwon Park <jaekwon.park@code-post.com>

# Disable SSH
#RUN rm -rf /etc/service/sshd \
#           /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Configure apt
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
RUN apt-get -y update && \
    C_ALL=C DEBIAN_FRONTEND=noninteractive apt-get -y install \
    apache2 \
    python-software-properties software-properties-common \
    libapache2-mod-php7.1 php7.1 ldap-utils && \
    apt-get clean && rm -r /var/lib/apt/lists/*

COPY apache2-foreground /usr/local/bin/
COPY get_public_key.php  .htaccess /var/www/html/
COPY get_id.sh /shell/

# Configure apache module
RUN a2dismod mpm_event && \
    a2enmod mpm_prefork rewrite && \
    touch /var/www/html/index.html && \
    chmod +x /shell/get_id.sh && \
    ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/stderr /var/log/apache2/error.log

#RUN rm -rf /etc/apache2/sites-available/000-default.conf 

WORKDIR /var/www/html

EXPOSE 80

CMD ["apache2-foreground"]
