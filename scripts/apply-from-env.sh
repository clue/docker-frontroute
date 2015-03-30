#!/usr/bin/env bash
if [ ! -f /etc/nginx/sites-enabled/default ]
then
    /apply-from-env.php
fi
sleep infinity

