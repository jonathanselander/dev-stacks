#!/usr/bin/env bash
set -ex

./bin/magento maintenance:enable

./bin/magento setup:install \
    --backend-frontname='admin' \
    --db-host='127.0.0.1' \
    --db-name='magento' \
    --db-user='magento' \
    --db-password='qwerty' \
    --session-save='redis' \
    --session-save-redis-host='127.0.0.1' \
    --session-save-redis-db='0' \
    --cache-backend='redis' \
    --cache-backend-redis-server='127.0.0.1' \
    --cache-backend-redis-db='1' \
    --page-cache='redis' \
    --page-cache-redis-server='127.0.0.1' \
    --page-cache-redis-db='2' \
    --admin-firstname='Admin' \
    --admin-lastname='Magento' \
    --admin-email='admin@example.com' \
    --admin-user='admin' \
    --admin-password='Qwerty123'

./bin/magento maintenance:enable

./bin/magento config:set --lock-config dev/debug/debug_logging 1
./bin/magento config:set --lock-config web/unsecure/base_url 'http://magento.localhost/'
./bin/magento config:set --lock-config web/seo/use_rewrites 1
./bin/magento config:set --lock-config web/url/use_store 1
./bin/magento config:set --lock-config catalog/search/engine 'elasticsearch5'
./bin/magento config:set general/locale/timezone UTC
./bin/magento config:set general/locale/code en_US

./bin/magento setup:performance:generate-fixtures ./setup/performance-toolkit/profiles/ce/small.xml
./bin/magento cache:flush
./bin/magento maintenance:disable
