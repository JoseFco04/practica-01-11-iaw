#!/bin/bash

# Muestra todos los comandos que se van ejecutando
set -ex

# Actualizamos los repositorios
apt update

# Actualizamos los paquetes
#apt upgrade -y

# Importamos el archivo de variables .env
source .env

# Eliminamos descargas previas 
rm -rf /tmp/wp-cli.phar

# Descargamos la utilidaad wp-cli 
wget  https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -P /tmp

# Le asignamos permisos de ejecución al archivo wp-cli.phar
chmod +x /tmp/wp-cli.phar

# Movemos la utilidad wp-cli al directorio /usr/local/bin
mv /tmp/wp-cli.phar /usr/local/bin/wp

# Eliminamos instalaciones previas de wordpress
rm -rf /var/www/html/*

# Descargamos el código fuente de WordPress en /var/www/html
wp core download --locale=es_ES --path=/var/www/html --allow-root

# Creamos el archivo wp-config 
wp config create \
  --dbname=$WORDPRESS_DB_NAME \
  --dbuser=$WORDPRESS_DB_USER \
  --dbpass=$WORDPRESS_DB_PASSWORD \
  --dbhost=$WORDPRESS_DB_HOST \
  --path=/var/www/html \
  --allow-root

  # Instalamos worpress
  wp core install \
  --url=$CB_DOMAIN \
  --title="$WORDPRESS_TITLE" \
  --admin_user=$WORDPRESS_ADMIN_USER \
  --admin_password=$WORDPRESS_ADMIN_PASS \
  --admin_email=$WORDPRESS_ADMIN_EMAIL \
  --path=/var/www/html \
  --allow-root

  # Actualizamos los pugins 
  wp core update --path=/var/www/html --allow-root

  # Actualizamos los temas 
  wp theme update --all --path=/var/www/html --allow-root

  # Instalo un tema
  wp theme install $TEMA --activate --path=/var/www/html --allow-root

  # 
  wp plugin update --all --path=/var/www/html --allow-root

  # Instalar y activar un  plugin
  wp plugin install $PLUGIN --activate --path=/var/www/html --allow-root
  wp plugin install $PLUGIN2 --activate --path=/var/www/html --allow-root

  # 
  wp rewrite structure '/%postname%/' --path=/var/www/html --allow-root

  # 
  wp option update wh1_page 'acceso' --path=/var/www/html --allow-root

  #
  cp ../htaccess/.htaccess /var/www/html

  # Modificamos el propietario y el grupo del directorio /var/www/html
  chown -R www-data:www-data /var/www/html

  # Copiamos el nuevo archivo .htaccess
  cp ../htaccess/.htaccess /var/www/html

  #Modificamos el propietario y el grupo del directorio /var/www/html
  chown -R www-data:www-data /var/www/html