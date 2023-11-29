#!/bin/bash

#Muestra todos los comandos que se van ejecutando
set -ex

#Actualizamos los repositorios
apt update

#Actualizamos los paquetes
#apt upgrade -y

# Importamos el archivo .env 
source .env

# Instalamos el nfs de cliente
apt install nfs-common -y

# Creamos el punto de montaje 
mount $NFS_SERVER_PRIVATE_IP:/var/www/html /var/www/html

# Añadimos iuna linea dde configuración al archivo /etc/fstab
# para que el punto de montaje se monte automaticamente
# después de cada reinicio

echo "$NFS_SERVER_PRIVATE_IP:/var/www/html /var/www/html  nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" >> /etc/fstab