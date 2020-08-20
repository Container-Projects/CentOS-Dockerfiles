#!/usr/bin/env bash
# Permissions
export USER_ID=$(id -u);
export GROUP_ID=$(id -g);
envsubst < /opt/scripts/passwd.template > /tmp/passwd;
export LD_PRELOAD=libnss_wrapper.so;
export NSS_WRAPPER_PASSWD=/tmp/passwd;
export NSS_WRAPPER_GROUP=/etc/group;

# Initialize and validate variables
CONFIG_DIR="/var/www/app/config"
DB_CONFIG_SAMPLE="${CONFIG_DIR}/database.sample.php"
DB_CONFIG_ACTUAL="${CONFIG_DIR}/database.php"

export DB_TYPE=${DB_TYPE:-"sqllite"};
export DB_HOST=${DB_HOST:-"localhost"};
export DB_SQLLITE_FILE=${DB_SQLLITE_FILE:-"/../database/production.sqlite"}
export DB_NAME=${DB_NAME:-"stickydb"};
export DB_USER=${DB_USER:-"sticky"};
export DB_PASSWD=${DB_PASSWD:-"sticky"};
export DB_PREFIX=${DB_PREFIX:-"sticky_"};

# Main Begins

if [ $1 == "sticky" ]; then
    envsubst < ${DB_CONFIG_SAMPLE} > ${DB_CONFIG_ACTUAL}
    exec /usr/sbin/httpd -DFOREGROUND;
else
    exec $@
fi
