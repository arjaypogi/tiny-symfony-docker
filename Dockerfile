FROM php:8.1-cli

RUN apt-get update \
    && apt-get install -y libpq-dev libzip-dev unzip \
    && docker-php-ext-install pdo_pgsql zip \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app

COPY . .

# Create a minimal Symfony environment for the container
RUN printf "APP_ENV=prod\nAPP_DEBUG=0\nAPP_SECRET=change-me-for-learning\n" > .env

RUN composer install \
    --no-interaction \
    --prefer-dist \
    --optimize-autoloader \
    --no-scripts

CMD ["sh", "-c", "php -S 0.0.0.0:${PORT:-8000} -t public"]