#!/bin/sh
# https://stackoverflow.com/a/57078300

ttyd -p 8082 -t enableZmodem=true bash > /opt/tyyd.log 2>&1 &

exec /usr/local/bin/dockerd-entrypoint.sh "$@" > /opt/dockerd.log 2>&1 
