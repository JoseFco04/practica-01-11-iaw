#!/bin/bash

#Muestra todos los comandos que se van ejecutando
set -ex

#Actualizamos los repositorios
apt update

#Actualizamos los paquetes
#apt upgrade -y

# Importamos el archivo .env 
source .env

# Instalamos el servicio NFS Server
apt install nfs-kernel-server -y

# Creamos el directorio que queremos compartir 
mkdir -p /var/www/html

# Modificamos el propietario y el grupo directorio
chown nobody:nogroup /var/www/html

# Copiamos el archivo exports a /etc/exports
cp ../exports/exports /etc/exports

# Reemplazamos la plantilla 
sed -i "s#NFS_FRONTEND_NETWORK#$NFS_FRONTEND_NETWORK#" /etc/exports

# Reiniciamos el servvicio de NFS
systemctl restart nfs-kernel-server

