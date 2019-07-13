#!/usr/bin/env bash
set -ex

docker-compose exec php composer install
docker-compose exec php ./bin/magento maintenance:enable

docker-compose exec php ./bin/magento setup:install \
    --backend-frontname='admin' \
    --db-host='127.0.0.1' \
    --db-name='magento' \
    --db-user='magento' \
    --db-password='magento' \
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
    --amqp-password='magento' \
    --admin-firstname='Magento' \
    --admin-lastname='Admin' \
    --admin-email='admin@example.com' \
    --admin-user='admin' \
    --admin-password='Qwerty123'

docker-compose exec php ./bin/magento maintenance:enable
docker-compose exec php ./bin/magento deploy:mode:set developer

docker-compose exec php ./bin/magento config:set --lock-config web/unsecure/base_url 'http://magento.localhost/'
docker-compose exec php ./bin/magento config:set --lock-config web/seo/use_rewrites 1
docker-compose exec php ./bin/magento config:set --lock-config web/url/use_store 1
docker-compose exec php ./bin/magento config:set --lock-config catalog/search/engine 'elasticsearch6'
docker-compose exec php ./bin/magento config:set --lock-config system/full_page_cache/caching_application '2'
docker-compose exec php ./bin/magento config:set --lock-config system/full_page_cache/varnish/access_list '127.0.0.1'
docker-compose exec php ./bin/magento config:set --lock-config system/full_page_cache/varnish/backend_host '127.0.0.1'
docker-compose exec php ./bin/magento config:set --lock-config system/full_page_cache/varnish/backend_port '8080'

docker-compose exec php ./bin/magento setup:config:set --http-cache-hosts=127.0.0.1:80

docker-compose exec php ./bin/magento config:set general/locale/timezone UTC
docker-compose exec php ./bin/magento config:set general/locale/code en_US

docker-compose exec php ./bin/magento setup:performance:generate-fixtures --skip-reindex ./setup/performance-toolkit/profiles/ce/${1:-small}.xml
docker-compose exec php ./bin/magento indexer:set-mode schedule
docker-compose exec php ./bin/magento indexer:reindex

docker-compose exec php ./bin/magento cache:flush
docker-compose exec php ./bin/magento maintenance:disable
