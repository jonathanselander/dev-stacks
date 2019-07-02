FROM docker.elastic.co/elasticsearch/elasticsearch:6.8.1

RUN ./bin/elasticsearch-plugin install --batch analysis-phonetic
RUN ./bin/elasticsearch-plugin install --batch analysis-icu

VOLUME /usr/share/elasticsearch/data
EXPOSE 9200
