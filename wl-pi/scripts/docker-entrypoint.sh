#!/bin/sh
set -e

echo "Inside docker-entrypoint.sh"

if [ -z "${ENABLE_WLPI}" ]; then
  echo "wlpi Disabled with env var, sleeping..."
  sleep 3600
  exit 0
fi

if [ "$1" = 'supervisord' ]; then
  echo "Starting supervisord"
  /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf
  exit
fi

echo "Executing '$@'"

exec "$@"
