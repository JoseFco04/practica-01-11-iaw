# Practica-01-11-IAW Jose Francisco León López
## En esta práctica debemos usar todas las máquinas de Amazon que habiamos creado hasta ahora: (Balanceador, los dos frontends,el backend y una máquina nueva que va a ser la del servidor NFS)
## La máquina del Servidor NFS debe verse así su configuración:
![1](https://github.com/JoseFco04/practica-01-11-iaw/assets/145347148/303af801-70d0-4f87-bb45-40bb8c68b342)
## Y su grupo de seguridad
![2](https://github.com/JoseFco04/practica-01-11-iaw/assets/145347148/c8e3ce5d-8cae-43f1-8f84-9bbdabbd2b01)
## Para que funcione nuestro servidor NFS hay que hacer dos scripts nuevos: Uno para el servidor NFS y otro para el cliente que este se va a ejecutar en alguna de las máquinas de los frontales.
### El script del servidor sería el siguiente paso por paso:
### Este script lo debemos ejecutar solo en la máquina del Servidor NFS.
#### Mostramos todos los comandos que se van ejecutando
~~~
set -ex
~~~
#### Actualizamos los repositorios
~~~
apt update
~~~
#### Actualizamos los paquetes
~~~
#apt upgrade -y
~~~
#### Importamos el archivo .env 
~~~
source .env
~~~
#### Instalamos el servicio NFS Server
~~~
apt install nfs-kernel-server -y
~~~
#### Creamos el directorio que queremos compartir 
~~~
mkdir -p /var/www/html
~~~
#### Modificamos el propietario y el grupo directorio
~~~
chown nobody:nogroup /var/www/html
~~~
#### Copiamos el archivo exports a /etc/exports
~~~
cp ../exports/exports /etc/exports
~~~
#### Reemplazamos la plantilla 
~~~
sed -i "s#NFS_FRONTEND_NETWORK#$NFS_FRONTEND_NETWORK#" /etc/exports
~~~
#### Reiniciamos el servvicio de NFS
~~~
systemctl restart nfs-kernel-server
~~~
### Una vez ejecutado este script nos vamos a alguno de los dos frontales que va a actuar de cliente nfs y ejecutamos el script del cliente nfs que paso por paso es este:
#### Muestra todos los comandos que se van ejecutando
~~~
set -ex
~~~
#### Actualizamos los repositorios
~~~
apt update
~~~
#### Actualizamos los paquetes
~~~
#apt upgrade -y
~~~
#### Importamos el archivo .env 
~~~
source .env
~~~
#### Instalamos el nfs de cliente
~~~
apt install nfs-common -y
~~~
#### Creamos el punto de montaje 
~~~
mount $NFS_SERVER_PRIVATE_IP:/var/www/html /var/www/html
~~~
#### Añadimos iuna linea dde configuración al archivo /etc/fstab
#### para que el punto de montaje se monte automaticamente
#### después de cada reinicio
~~~
echo "$NFS_SERVER_PRIVATE_IP:/var/www/html /var/www/html  nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" >> /etc/fstab
~~~
### Antes de esto tenemos que tener ocnfigurado la carpeta exports con el archivo exports en la carpeta /etc
#### El archivo se vería así:
~~~
/var/www/html NFS_FRONTEND_NETWORK(rw,sync,no_root_squash,no_subtree_check)
~~~
#### El nfs_frontend_network lo buscaremos y remplazaremos por la ip privada del servidor nfs
