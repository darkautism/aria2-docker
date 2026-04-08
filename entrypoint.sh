#!/bin/sh
set -e

if [ ! -f /config/aria2.conf ]; then
    cp /etc/aria2/aria2.conf /config/aria2.conf
fi

if [ -n "$RPC_SECRET" ]; then
    exec aria2c --conf-path=/config/aria2.conf --rpc-secret="$RPC_SECRET" "$@"
else
    echo "ERROR: RPC_SECRET environment variable is required"
    echo "Please set RPC_SECRET when running the container:"
    echo "  docker run -d -e RPC_SECRET=your-secret-token ..."
    exit 1
fi