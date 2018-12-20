FROM docker.elastic.co/elasticsearch/elasticsearch:6.5.4

RUN ./bin/elasticsearch-plugin install --batch analysis-phonetic
RUN ./bin/elasticsearch-plugin install --batch analysis-icu

EXPOSE 9200
EXPOSE 9300
