#!/bin/sh

echo "Changing www pool parameters in PHP-FPM"

#### set some defaults if this image is not derived

[ -z "$phpfpm_max_input_vars" ] && phpfpm_max_input_vars=10000
[ -z "$phpfpm_memory_lmit" ] && phpfpm_memory_limit=128M
[ -z "$phpfpm_post_max_size" ] && phpfpm_post_max_size=128M
[ -z "$phpfpm_upload_max_filesize" ] && phpfpm_upload_max_filesize=128M
[ -z "$phpfpm_max_execution_time" ] && phpfpm_max_execution_time=120
[ -z "$phpfpm_pm_max_children" ] && phpfpm_pm_max_children=5
[ -z "$phpfpm_governor" ] && phpfpm_pm_max_children=ondemand

echo "php_admin_value[max_input_vars] = $phpfpm_max_input_vars" >> /etc/php/7.0/fpm/pool.d/www.conf
echo "php_admin_value[post_max_size] = $phpfpm_post_max_size"   >> /etc/php/7.0/fpm/pool.d/www.conf
echo "php_admin_value[upload_max_filesize] = $phpfpm_upload_max_filesize"   >> /etc/php/7.0/fpm/pool.d/www.conf
echo "php_admin_value[max_execution_time] = $phpfpm_max_execution_time"   >> /etc/php/7.0/fpm/pool.d/www.conf
echo ";avoid memory leaks by recycling the process every 5000 requests" >>  /etc/php/7.0/fpm/pool.d/www.conf
echo "pm.max_requests = 5000" >> /etc/php/7.0/fpm/pool.d/www.conf 

if [ "$phpfpm_governor" = "static" ]; then

	echo "Set governor to static"
	sed -i -e "s/pm = dynamic/pm = static/" /etc/php/7.0/fpm/pool.d/www.conf
	echo "Set max children"
	sed -i -e "s/pm.max_children = 5/pm.max_children = $phpfpm_pm_max_children/" /etc/php/7.0/fpm/pool.d/www.conf

else
	echo "Set governor to ondemand"
	sed -i -e "s/pm = dynamic/pm = ondemand/" /etc/php/7.0/fpm/pool.d/www.conf
fi

echo "Ioncube loader setup"
sed -i '1s/^/zend_extension = \/usr\/local\/ioncube\/ioncube_loader_lin_7.0.so\n/' /etc/php/7.0/fpm/php.ini

echo "Change Apache security configuration"
sed -i -E 's/ServerTokens(.*)$/ServerTokens Prod/' /etc/apache2/conf-enabled/security.conf
sed -i -E 's/ServerSignature(.*)$/ServerSignature Off/' /etc/apache2/conf-enabled/security.conf

#echo "Reconfigure database settings in Wordpress"
#sed -i "/DB_HOST/s/'[^']*'/$db_hostname/2" /var/www/html/wp-config.php
#sed -i "/DB_NAME/s/'[^']*'/$db_name/2" /var/www/html/wp-config.php
#sed -i "/DB_USER/s/'[^']*'/$db_username/2" /var/www/html/wp-config.php
#sed -i "/DB_PASSWORD/s/'[^']*'/$db_password/2" /var/www/html/wp-config.php

echo "Starting services... "
#### we use restart, just in case ####
service apache2 restart
service php7.0-fpm restart
tail -f /var/log/apache2/access.log
#if using supervisord run that instead of the above three lines
