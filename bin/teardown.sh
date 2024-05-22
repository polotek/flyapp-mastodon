APP_NAME="polotek-social"
DB_NAME="$APP_NAME-db"
REDIS_NAME="$APP_NAME-redis"
VOLUME_NAME="$(fly volumes list -a $APP_NAME -t json | jq -r '.[].id')"

fly machines stop -a $APP_NAME

fly redis destroy $REDIS_NAME

fly pg detach $DB_NAME
fly apps destroy $DB_NAME

fly volumes list -j| jq -r '.[].id'
fly volumes destroy $(fly volumes list -a $APP_NAME -t json | jq -r '.[].id')

fly apps destroy $APP_NAME
