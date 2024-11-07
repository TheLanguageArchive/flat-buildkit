FROM php:8.3-fpm

ENV DRUPAL_DATABASE_HOST postgres
ENV DRUPAL_DATABASE_USER admin
ENV DRUPAL_DATABASE_PASSWORD drupal
ENV DRUPAL_DATABASE_NAME drupal

RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    git \
    unzip \
    postgresql-client \
    libpq-dev \
    libicu-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_pgsql intl

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Copy the install script
COPY install-drupal.sh /usr/local/bin/install-drupal.sh
RUN chmod +x /usr/local/bin/install-drupal.sh

WORKDIR /var/www/html