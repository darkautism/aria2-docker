#!/bin/sh
set -e

if [ ! -f /config/aria2.conf ]; then
    cp /etc/aria2/aria2.conf /config/aria2.conf
fi

exec aria2c --conf-path=/config/aria2.conf "$@"