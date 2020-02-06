## Docker Spark
This image is for Spark. This is based on the docker-hadoop-base image and contains spark 2.2.0 installation. This image downloads Spark 2.2.0 parcel file (SPARK2-2.2.0.cloudera1-1.cdh5.12.0.p0.142354-el7.parcel) during build and put that in /usr/local/spark. This also sets related environment variables like SPARK_HOME, SPARK_CONF_DIR etc.

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