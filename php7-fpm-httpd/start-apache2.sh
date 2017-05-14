#!/bin/bash
#not used directly, but may be helpful if someone wants to modify the Dockerfile
source /etc/apache2/envvars
exec apache2 -D FOREGROUND
