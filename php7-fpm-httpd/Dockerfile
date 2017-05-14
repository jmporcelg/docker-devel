FROM debian:jessie
MAINTAINER Jose Porcel
LABEL development_type="php" php_version="7.0" web_server="apache2"
# Add Key
RUN DEBIAN_FRONTEND=noninteractive apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install wget
RUN wget https://www.dotdeb.org/dotdeb.gpg
RUN echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list
RUN echo "deb-src http://packages.dotdeb.org jessie all"  >> /etc/apt/sources.list
RUN DEBIAN_FRONTEND=noninteractive apt-key add dotdeb.gpg
# Install packages
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apt-utils
# Update
RUN DEBIAN_FRONTEND=noninteractive apt-get update
# Install dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install git 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php7.0-mysql 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php7.0-soap 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install pwgen 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php7.0-curl
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php7.0-zip
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php7.0-mbstring
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php7.0-gd
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php7.0-imagick
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php7.0-mcrypt
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php7.0-intl
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php7.0-xsl
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php-fpm
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2-mpm-event
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install curl

# nodejs, optional: copy the .sh script locally after reviewing and change the URL
RUN curl -sL https://deb.nodesource.com/setup_6.x -o /root/nodesource_setup.sh && bash /root/nodesource_setup.sh
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install nodejs build-essential
RUN npm install gulp -g

# clean packages
RUN DEBIAN_FRONTEND=noninteractive apt-get autoclean

# Add image configuration and scripts, ioncube loader betha
RUN mkdir -p /usr/local/ioncube/
COPY ioncube_loader_lin_*.so /usr/local/ioncube/
ADD run.sh /run.sh
RUN chmod 755 /*.sh

# config to enable .htaccess
ADD apache_default /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite mpm_event proxy proxy_fcgi
RUN a2enconf php7.0-fpm
RUN rm -Rf /var/www/html/*.html
EXPOSE 80 
CMD ["/run.sh"]
