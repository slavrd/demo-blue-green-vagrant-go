#!/usr/bin/env bash
# Switches ngnix configurations based on input

# Define Variables
INPUT=$1
CONFIG_STORE_PATH="../nginx-configs"
NGINX_CONFIG_PATH="/etc/nginx/sites-available/default"

# replace config and restart nginx
if [ -f $CONFIG_STORE_PATH/$INPUT ]; then
    sudo cp $CONFIG_STORE_PATH/$INPUT $NGINX_CONFIG_PATH
    sudo service nginx restart
else
    echo "configuration: $CONFIG_STORE_PATH/$INPUT does not exist."
fi
