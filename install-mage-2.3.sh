#!/usr/bin/env bash
set -ex

magerun maintenance:enable

magerun setup:install \
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

magerun maintenance:enable
magerun deploy:mode:set developer

magerun config:set --lock-config web/unsecure/base_url 'http://magento.localhost/'
magerun config:set --lock-config web/seo/use_rewrites 1
magerun config:set --lock-config web/url/use_store 1
magerun config:set --lock-config catalog/search/engine 'elasticsearch6'
magerun config:set --lock-config system/full_page_cache/caching_application '2'
magerun config:set --lock-config system/full_page_cache/varnish/access_list '127.0.0.1'
magerun config:set --lock-config system/full_page_cache/varnish/backend_host '127.0.0.1'
magerun config:set --lock-config system/full_page_cache/varnish/backend_port '8080'

magerun config:set general/locale/timezone UTC
magerun config:set general/locale/code en_US

magerun setup:performance:generate-fixtures --skip-reindex ./setup/performance-toolkit/profiles/ce/small.xml
magerun indexer:set-mode schedule
magerun indexer:reindex

magerun cache:flush
magerun sys:info
magerun maintenance:disable
