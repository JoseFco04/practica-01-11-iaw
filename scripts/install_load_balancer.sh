#!/bin/bash

#Muestra todos los comandos que se van ejecutando
set -ex

#Actualizamos los repositorios
apt update

#Actualizamos los paquetes
#apt upgrade -y

#Importamos el archivo de variables 
source .env

#Instalamos el servidor web Apache
sudo apt install apache2 -y

# Habilitamos los módulos necesarios para configurar Apache como proxy inverso
a2enmod proxy
a2enmod proxy_http
a2enmod proxy_balancer

# Para activar este método de balance tenemos que activar el módulo lbmethod_byrequests:
a2enmod lbmethod_byrequests

# Copiamos el archivo de configuración 
cp ../conf/load-balancer.conf /etc/apache2/sites-available

# Reemplazamos los valores de la plantilla por las direcciones ip de los frontales
sed -i "s/IP_HTTP_SERVER_1/$IP_HTTP_SERVER_2/" /etc/apache2/sites-available/load-balancer.conf
sed -i "s/IP_HTTP_SERVER_2/$IP_HTTP_SERVER_1/" /etc/apache2/sites-available/load-balancer.conf

# Habilitamos el VirtualHost que hemos creado 
a2ensite load-balancer.conf 

# Deshabilitamos el VirtualHost que tiene Apache por defecto
a2dissite 000-default.conf

# Reiniciamos el servicio de apache
systemctl restart apache2

