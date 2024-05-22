#!/bin/bash
set -e
set -o xtrace

APP_NAME=polotek-social
APP_NAME_UNDERSCORE=polotek_social

fly apps create $APP_NAME

# Redis (queues, cache, etc)
REDIS_NAME=$APP_NAME"-redis"
fly redis create \
    --region sjc \
    --name "$REDIS_NAME" \
    --enable-eviction \
    --no-replicas

# Storage (files, media, etc)
VOLUME_NAME=$APP_NAME_UNDERSCORE"_uploads"
fly volumes create --region sjc -y $VOLUME_NAME

# Database
DB_NAME="$APP_NAME-db"
fly pg create \
    --region sjc \
    --vm-size "shared-cpu-1x" \
    --initial-cluster-size 1 \
    --volume-size 1 \
    --name "$DB_NAME"

fly pg attach "$DB_NAME"

./bin/gen_secrets.sh

fly deploy -C fly.setup.toml
