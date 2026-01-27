#!/bin/bash

REDIS_USER_PASS=$(cat /run/secrets/redis_user_password)

exec redis-server /etc/redis/redis.conf --requirepass $REDIS_USER_PASS
