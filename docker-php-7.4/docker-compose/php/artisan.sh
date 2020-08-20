#!/bin/bash
set -e

if [ "$APP_AUTOGENERATE" = "false" ]; then
    php artisan config:cache
    php artisan cache:clear
    php artisan key:generate
    php artisan optimize:clear
    chown -R www-data:www-data /var/www/html/suite/storage
fi

su - $RUN_AS -c "$@" -s /bin/bash