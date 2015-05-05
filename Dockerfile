FROM ubuntu:trusty
MAINTAINER Fernando Mayo <fernando@tutum.co>

# Install base packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        curl \
        apache2 \
        libapache2-mod-php5 \
        php5-mysql \
        php5-sqlite \
        php5-imagick \
        php5-mongo \
        php5-mcrypt \
        php5-intl \
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


# Change group membership to allow editing of mounted directories.
# NOTE: This only works from small, simple apps. Symfony for example does not work like this.
# @see https://github.com/boot2docker/boot2docker/issues/581#issuecomment-68227494
RUN usermod -u 1000 www-data


# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh

RUN rm -Rf /var/www/html
ADD www/ /var/www/html

EXPOSE 80
WORKDIR /app
CMD ["/run.sh"]
