## Docker Hive
This image is for Hive. This is based on the docker-hadoop-base image and contains hive 1.1 installation. This image downloads hive 1.1 tar file (hive-1.1.0-cdh5.12.1.tar.gz) during build and put that in /usr/local/hive. This also sets related environment variables like HIVE_HOME, HIVE_CONF_DIR etc.

## Metastore
This image uses an external postgressql database as metastore.

## Environment Variables
This image uses following environment variables:
* KERBEROS_HOST - Hostname of KDC server
* KERBEROS_REALM - Kerberos realm
* DOMAIN_REALM - Kerberos domain realm
* KERBEROS_ADMIN - KDC admin username
* KERBEROS_ADMIN_PASSWORD - KDC admin password
* NAMENODE_HOST - Hostname of namenode
* RESOURCEMANAGER_HOST - Hostname of resourcemanager node
* YARN_SCHEDULER_MIN_ALLOC_MB - Minimum memory allocation for YARN Scheduler
* YARN_SCHEDULER_MAX_ALLOC_MB - Maximum memory allocation for YARN Scheduler
* YARN_SCHEDULER_MIN_ALLOC_VCORES - Minimum virtual cpu cores for YARN Scheduler
* YARN_SCHEDULER_MAX_ALLOC_VCORES - Maximum virtual cpu cores for YARN Scheduler
* YARN_NM_RESOURCE_MEM_MB - Memory for resource manager
* YARN_NM_RESOURCE_CPU_VCORES - Virtual cpu cores for resource manager