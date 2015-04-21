FROM ubuntu:trusty
MAINTAINER Fernando Mayo <fernando@tutum.co>

# Install base packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        curl \
        apache2 \
        libapache2-mod-php5 \
        php5-mysql \
        php5-gd \
        php5-curl \
        php-pear \
        php-apc && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini

RUN rm -f /etc/apache2/sites-enabled/000-default.conf
ADD apache/sites-enabled/000-default.conf   /etc/apache2/sites-enabled/000-default.conf

# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh

RUN rm -Rf /var/www/html
ADD sample/ /var/www/html

EXPOSE 80
WORKDIR /app
CMD ["/run.sh"]
