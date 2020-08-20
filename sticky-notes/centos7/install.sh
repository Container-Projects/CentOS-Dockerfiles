#!/usr/bin/env bash

set -eux;

# Initialize variables
HTTPD_CONF="/etc/httpd/conf/httpd.conf"
HTTPD_WELCOME="/etc/httpd/conf.d/welcome.conf"

INSTALL_PKGS1="wget git";
INSTALL_PKGS2="httpd nss_wrapper gettext";
REMI_REPO="https://rpms.remirepo.net/enterprise/remi-release-7.rpm"
PHP_REMI_VERSION="${PHP_REMI_VERSION:-"php71"}"

PHP1="${PHP_REMI_VERSION} ${PHP_REMI_VERSION}-php ${PHP_REMI_VERSION}-php-pgsql ${PHP_REMI_VERSION}-php-mysqlnd"
PHP2="${PHP_REMI_VERSION}-php-pecl-mysql ${PHP_REMI_VERSION}-php-gd ${PHP_REMI_VERSION}-php-pecl-mongodb"
PHP3="${PHP_REMI_VERSION}-php-pecl-redis ${PHP_REMI_VERSION}-php-phpiredis ${PHP_REMI_VERSION}-php-mcrypt"

PHP_MSSQL_PACKAGES="${PHP_REMI_VERSION}-php-sqlsrv"

PHP_PACKAGES="${PHP1} ${PHP2} ${PHP3} ${PHP_MSSQL_PACKAGES}";
INSTALL_PKGS="${INSTALL_PKGS2} ${PHP_PACKAGES}";

CONFIG_DIR="/var/www/app/config"
DB_CONFIG_SAMPLE="${CONFIG_DIR}/database.sample.php"

MSSQL_REPODATA="https://packages.microsoft.com/config/rhel/7/prod.repo";

export ACCEPT_EULA="Y";
export MOODLE_DATA="/var/moodledata";

# Sticky stuff
STICKY_NAME="sticky-notes"
STICKY_DIR="/var/www"
STICKY_APP="${STICKY_DIR}/app"
STICKY_BOOTSTRAP="${STICKY_DIR}/bootstrap"
STICKY_INDEX="${STICKY_DIR}/html/index.php"
STICKY_PATHS="${STICKY_BOOTSTRAP}/paths.php"
STICKY_URL="https://github.com/sayakb/${STICKY_NAME}.git"

# INSTALL BEGINS

# Setup repositories
yum -y install ${INSTALL_PKGS1}
pushd /etc/yum.repos.d && wget ${MSSQL_REPODATA} && popd

# Setup necessary packages
yum -y install epel-release && yum -y install ${REMI_REPO} && yum -y install --skip-broken ${INSTALL_PKGS}

# Install sticky-notes
git clone ${STICKY_URL};
pushd ./${STICKY_NAME};
cp -avrf public/* /var/www/html;
cp -avrf * /var/www/;
popd;
rm -rf ${STICKY_NAME} && rm -rf "${STICKY_DIR}/public" && ln -s "${STICKY_DIR}/html" "${STICKY_DIR}/public";

# Fixup Configurations
rm -rf ${HTTPD_WELCOME};
sed -i 's/^Listen 80/Listen 8080\\\nListen 8443/g' ${HTTPD_CONF};
sed -i 's/^Listen 8080\\/Listen 8080/g' ${HTTPD_CONF};
sed -i 's/^Group apache/Group root/g' ${HTTPD_CONF};
sed -i 's/logs\/error_log/\/dev\/stderr/g' ${HTTPD_CONF};
sed -i 's/logs\/access_log/\/dev\/stdout/g' ${HTTPD_CONF};
mkdir -p /etc/httpd/logs && touch /etc/httpd/logs/error_log && touch /etc/httpd/logs/access_log;

cp ${DB_CONFIG_SAMPLE} ${DB_CONFIG_SAMPLE}.bak;
sed -i "s/\/\.\.\/database\/production\.sqlite/\$\{DB_SQLLITE_FILE\}/g
        s/localhost/\$\{DB_HOST\}/g
        s/'database',/'\$\{DB_NAME\}',/g
        s/root/\$\{DB_USER\}/g
        s/'password'  => ''/'password'  => '\$\{DB_PASSWD\}'/g
        s/'password' => ''/'password' => '\$\{DB_PASSWD\}'/g
        s/'default' => 'mysql'/'default' => '\$\{DB_TYPE\}'/g" ${DB_CONFIG_SAMPLE}

sed -i 's/\.\.\/public/\.\.\/html/g' ${STICKY_PATHS}

# Fix the permissions
for item in "/etc/httpd" "/var/www"; do
    . /opt/scripts/fix-permissions.sh ${item} apache;
done

chmod -R 777 /etc/httpd/logs;

# Cleanup
yum -y remove ${INSTALL_PKGS1} && yum clean all
