#!/usr/bin/env bash
set -ex

touch maintenance.flag

php install.php \
    --license_agreement_accepted yes \
    --locale en_US \
    --timezone UTC \
    --default_currency USD \
    --db_host 127.0.0.1 \
    --db_name magento \
    --db_user magento \
    --db_pass qwerty \
    --use_secure no \
    --use_secure_admin no \
    --skip_url_validation yes \
    --url "http://magento.localhost/" \
    --secure_base_url "http://magento.localhost/" \
    --use_rewrites yes \
    --admin_email admin@example.com \
    --admin_firstname Admin \
    --admin_lastname Magento \
    --admin_username admin \
    --admin_password qwerty123

magerun index:reindex:all
magerun cache:enable
magerun cache:flush

rm -rf maintenance.flag
