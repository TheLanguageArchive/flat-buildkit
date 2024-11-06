FROM drupal:11.0.5-php8.3-fpm-bullseye

EXPOSE 80

ENV DRUPAL_DATABASE_HOST postgres
ENV DRUPAL_DATABASE_USER admin
ENV DRUPAL_DATABASE_PASSWORD drupal
ENV DRUPAL_DATABASE_NAME drupal

RUN apt-get update && apt-get install -y postgresql-client unzip
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

