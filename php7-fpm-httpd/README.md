# PHP7 development environment

This Dockerfile setups PHP-FPM with PHP7 and Apache.

This can be derived in your own project with something like:

    FROM docker-devel/php7-fpm-httpd
    # must define PHP overrides 
    ENV phpfpm_memory_limit=512M \ 
        phpfpm_max_input_vars=10000 \
        phpfpm_post_max_size=128M \
        phpfpm_upload_max_filesize=128M \
        phpfpm_max_execution_time=120 \
        phpfpm_pm_max_children=5 \
        phpfpm_governor=ondemand
    
    ENV s_vhosts="staging.mydomain.com" \
        p_vhosts="www.mydomain.com"

    # add the source code to the web root in Apache
    COPY . /var/www/html

    # re-own files
    RUN /bin/chown -R www-data:www-data /var/www/html/*
    WORKDIR /var/www/html

Few parameters can be tweaked in the above example, otherwise, default values will apply.

# how to build

    docker build -t docker-devel/php7httpd .
    
# how to run

Here is an example:

    docker run -v /workspace/phpcode/:/var/www/html/ -p80:80 --name mydevelenv php7httpd
    

    
