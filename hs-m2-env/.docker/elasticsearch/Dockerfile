FROM docker.elastic.co/elasticsearch/elasticsearch:5.6.14

RUN ./bin/elasticsearch-plugin install --batch analysis-phonetic
RUN ./bin/elasticsearch-plugin install --batch analysis-icu

EXPOSE 9200
EXPOSE 9300
