# Usar la imagen oficial de PHP con FPM (FastCGI Process Manager)
FROM php:8.2-fpm

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    curl \
    zip \
    unzip \
    git \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    && docker-php-ext-install pdo_mysql mbstring zip

# Instalar Composer (gestor de dependencias de PHP)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Establecer el directorio de trabajo dentro del contenedor
WORKDIR /var/www

# Copiar el archivo de la aplicación (todos los archivos del proyecto)
COPY . .

# Instalar las dependencias de Composer
RUN composer install --no-dev --optimize-autoloader

# Copiar archivo de configuración de Nginx si se usa Nginx (opcional)
# COPY docker/nginx.conf /etc/nginx/nginx.conf

# Establecer permisos
RUN chown -R www-data:www-data /var/www

# Exponer el puerto 8000 (puerto por defecto de Laravel)
EXPOSE 8000

# Comando por defecto para ejecutar el servidor PHP
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
