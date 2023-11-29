#!/bin/bash

#Muestra todos los comandos que se van ejecutando
set -ex

#Actualizamos los repositorios
apt update

#Actualizamos los paquetes
#apt upgrade -y

# Importamos el archivo .env 
source .env

#Instalamos el gestor de bases de datos MySQL
apt install mysql-server -y

# Configuramos mysql para que solo acepte conexiones desde la Ip privada
sed -i "s/127.0.0.1/$MYSQL_PRIVATE_IP/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Reiniciamos el servicio de mysql
systemctl restart mysql
