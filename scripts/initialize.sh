#!/bin/bash

# remove default server configuration if requested
if [ "$NGINX_DEFAULT_SERVER" == "off" ]; then
    echo "env: NGINX_DEFAULT_SERVER: [ ${NGINX_DEFAULT_SERVER} ] - removing default server configuration"
    rm -f /etc/nginx/conf.d/default.conf
fi


# add custom nginx config include path
if [ -z ${NGINX_INCLUDE_PATH+x} ] || [ "$NGINX_INCLUDE_PATH" == "" ]; then
    echo "env: NGINX_INCLUDE_PATH not specified: [ SKIP ]"
else
    echo "env: NGINX_INCLUDE_PATH: [ ${NGINX_INCLUDE_PATH} ]"
    sed -i "/custom configurations/cinclude ${NGINX_INCLUDE_PATH}; # include custom configurations" /etc/nginx/nginx.conf

    for f in ${NGINX_INCLUDE_PATH}; do
        echo "conf: $f";
    done
fi
