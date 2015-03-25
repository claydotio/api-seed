#!/bin/sh
export NODE_ENV=production

./node_modules/pm2/bin/pm2 start ./bin/server.coffee \
  -i 0 \
  --name api \
  --no-daemon \
  -o /var/log/acme/api.log \
  -e /var/log/acme/api.error.log;
