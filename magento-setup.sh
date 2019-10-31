#!/usr/bin/env bash
set -ex

docker-compose exec magento magerun setup:install \
  --backend-frontname='admin' \
  --db-host='mysql' \
  --db-name='magento' \
  --db-user='magento' \
  --db-password='magento' \
  --session-save='redis' \
  --session-save-redis-host='redis' \
  --session-save-redis-db='0' \
  --cache-backend='redis' \
  --cache-backend-redis-server='redis' \
  --cache-backend-redis-db='1' \
  --page-cache='redis' \
  --page-cache-redis-server='redis' \
  --page-cache-redis-db='2' \
  --amqp-host='rabbitmq' \
  --amqp-virtualhost='magento' \
  --amqp-user='magento' \
  --amqp-password='magento' \
  --admin-firstname='Magento' \
  --admin-lastname='Admin' \
  --admin-email='admin@example.com' \
  --admin-user='admin' \
  --admin-password='Qwerty123'

docker-compose exec magento magerun maintenance:enable
docker-compose exec magento magerun deploy:mode:set developer

docker-compose exec magento magerun config:set --lock-env web/unsecure/base_url 'http://magento.localhost/'
docker-compose exec magento magerun config:set --lock-env web/secure/base_url 'http://magento.localhost/'
docker-compose exec magento magerun config:set --lock-env web/secure/use_in_frontend 0
docker-compose exec magento magerun config:set --lock-env web/secure/use_in_adminhtml 0
docker-compose exec magento magerun config:set --lock-env web/url/redirect_to_base 1
docker-compose exec magento magerun config:set --lock-env web/url/use_store 1
docker-compose exec magento magerun config:set --lock-env web/seo/use_rewrites 1

docker-compose exec magento magerun config:set --lock-env catalog/search/engine 'elasticsearch6'
docker-compose exec magento magerun config:set --lock-env catalog/search/elasticsearch6_server_hostname 'elasticsearch'
docker-compose exec magento magerun config:set --lock-env catalog/search/elasticsearch6_server_port '9200'
docker-compose exec magento magerun config:set --lock-env catalog/search/elasticsearch6_index_prefix 'magento'
docker-compose exec magento magerun config:set --lock-env catalog/search/elasticsearch6_server_timeout '10'
docker-compose exec magento magerun config:set --lock-env catalog/search/elasticsearch6_enable_auth '0'

docker-compose exec magento magerun config:set --lock-env system/full_page_cache/caching_application '2'
docker-compose exec magento magerun config:set --lock-env system/full_page_cache/varnish/access_list 'magento'
docker-compose exec magento magerun config:set --lock-env system/full_page_cache/varnish/backend_host 'nginx'
docker-compose exec magento magerun config:set --lock-env system/full_page_cache/varnish/backend_port '80'

docker-compose exec magento magerun setup:config:set --http-cache-hosts=varnish:80

docker-compose exec magento magerun config:set general/locale/timezone UTC
docker-compose exec magento magerun config:set general/locale/code en_US

docker-compose exec magento magerun setup:performance:generate-fixtures --skip-reindex ./setup/performance-toolkit/profiles/ce/${1:-small}.xml
docker-compose exec magento magerun indexer:set-mode schedule
docker-compose exec magento magerun indexer:reindex

docker-compose exec magento magerun cache:flush
docker-compose exec magento magerun sys:info
docker-compose exec magento magerun maintenance:disable
