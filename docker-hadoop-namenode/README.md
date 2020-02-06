## Docker Hadoop Namenode
This image is for Hadoop namenode. 
This is based on the docker-hadoop-base image and contains the startup script for namenode (start-hadoop-namenode).

## Environment Variables
This image uses following environment variables:
* KERBEROS_HOST - Hostname of KDC server
* KERBEROS_REALM - Kerberos realm
* DOMAIN_REALM - Kerberos domain realm
* KERBEROS_ADMIN - KDC admin username
* KERBEROS_ADMIN_PASSWORD - KDC admin password