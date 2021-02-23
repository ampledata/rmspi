#!/bin/bash
echo "Inside docker-entrypoint.sh"
set -ex

if [ "$1" = "nginx" ]; then
  echo "Starting nginx ..."
  nginx -g 'daemon off;' -c /nginx-proxy/nginx.conf
fi

echo "Executing '$@'"

exec "$@"
