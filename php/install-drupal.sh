#!/bin/bash
set -e

# Wait for PostgreSQL to be ready
until PGPASSWORD="$POSTGRES_PASSWORD" pg_isready -h "$DRUPAL_DB_HOST" -U "postgres"; do
  echo "Waiting for PostgreSQL..."
  sleep 2
done

# Create the database and user if they don't exist
echo "Checking PostgreSQL for existing database and user..."
PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$DRUPAL_DB_HOST" -U "postgres" -tc "SELECT 1 FROM pg_database WHERE datname = '$DRUPAL_DB_NAME'" | grep -q 1 || \
PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$DRUPAL_DB_HOST" -U "postgres" -c "CREATE DATABASE $DRUPAL_DB_NAME"
PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$DRUPAL_DB_HOST" -U "postgres" -tc "SELECT 1 FROM pg_roles WHERE rolname = '$DRUPAL_DB_USER'" | grep -q 1 || \
PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$DRUPAL_DB_HOST" -U "postgres" -c "CREATE USER $DRUPAL_DB_USER WITH PASSWORD '$DRUPAL_DB_PASSWORD'"
PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$DRUPAL_DB_HOST" -U "postgres" -c "GRANT ALL PRIVILEGES ON DATABASE $DRUPAL_DB_NAME TO $DRUPAL_DB_USER"

# Grant usage and creation privileges on the public schema to the DRUPAL_DB_USER
PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$DRUPAL_DB_HOST" -U "postgres" -d "$DRUPAL_DB_NAME" -c "GRANT ALL ON SCHEMA public TO $DRUPAL_DB_USER"
PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$DRUPAL_DB_HOST" -U "postgres" -d "$DRUPAL_DB_NAME" -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO $DRUPAL_DB_USER"

# Set bytea_output to 'escape' for Drupal compatibility
PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$DRUPAL_DB_HOST" -U "postgres" -d "$DRUPAL_DB_NAME" -c "ALTER DATABASE \"$DRUPAL_DB_NAME\" SET bytea_output = 'escape'"

# If composer.json does not exist, download Drupal with Composer
if [ ! -f /var/www/html/composer.json ]; then
  echo "Installing Drupal with Composer..."
  composer create-project drupal/recommended-project /var/www/html/web
  chown -R www-data:www-data /var/www/html/web
fi

# Install Drush
composer require --dev drush/drush

# Install Drupal site if not already installed
if [ ! -f /var/www/html/web/sites/default/settings.php ]; then

  # Navigate to the Drupal project directory
  cd /var/www/html/web

  # Run the installation using Drush
  drush si standard \
    --db-url="pgsql://${DRUPAL_DB_USER}:${DRUPAL_DB_PASSWORD}@${DRUPAL_DB_HOST}/${DRUPAL_DB_NAME}" \
    --site-name="The Language Archive" \
    --account-name=admin \
    --account-pass=islandora \
    --yes
else
  echo "Drupal is already installed."
fi

# Start PHP-FPM
php-fpm