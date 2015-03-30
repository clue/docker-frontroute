#!/usr/bin/env bash
# Check whether the config file is already present
while [ ! -f /etc/nginx/sites-enabled/default ]
do
  sleep 2
done
# Now start nginx
nginx
