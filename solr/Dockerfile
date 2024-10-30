FROM solr:9.7.0

EXPOSE 8983

WORKDIR /opt/solr

# Defaults environment variables to be overloaded.
ENV \
    SOLR_JAVA_OPTS= \
    SOLR_JETTY_OPTS=-Dsolr.jetty.host=0.0.0.0 \
    SOLR_LOG_LEVEL=INFO \
    SOLR_MEMORY=512m

