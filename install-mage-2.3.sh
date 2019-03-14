#!/usr/bin/env bash
set -ex

magerun2 maintenance:enable

magerun2 setup:install \
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
    --amqp-host='127.0.0.1' \
    --amqp-virtualhost='magento' \
    --amqp-user='magento' \
    --amqp-password='qwerty' \
    --admin-firstname='Admin' \
    --admin-lastname='Magento' \
    --admin-email='admin@example.com' \
    --admin-user='admin' \
    --admin-password='Qwerty123'

magerun2 maintenance:enable
magerun2 deploy:mode:set developer

magerun2 config:set --lock-config dev/debug/debug_logging 1
magerun2 config:set --lock-config web/unsecure/base_url 'http://magento.localhost/'
magerun2 config:set --lock-config web/seo/use_rewrites 1
magerun2 config:set --lock-config web/url/use_store 1
magerun2 config:set --lock-config catalog/search/engine 'elasticsearch5'
magerun2 config:set --lock-config system/full_page_cache/caching_application '2'
magerun2 config:set --lock-config system/full_page_cache/varnish/access_list '127.0.0.1'
magerun2 config:set --lock-config system/full_page_cache/varnish/backend_host '127.0.0.1'
magerun2 config:set --lock-config system/full_page_cache/varnish/backend_port '8080'

magerun2 config:set general/locale/timezone UTC
magerun2 config:set general/locale/code en_US

magerun2 setup:performance:generate-fixtures ./setup/performance-toolkit/profiles/ce/small.xml
magerun2 cache:flush

magerun2 sys:info
magerun2 sys:check

magerun2 maintenance:disable
