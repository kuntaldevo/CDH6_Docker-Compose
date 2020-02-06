## Docker Pipeline
This image is for Paxata Pipeline. This is based on the docker-spark image and contains pipeline binaries. However, pipeline binaries are not included in GIT. This image assumes the pipeline binaries will be avilable in required location (i.e. under files/pipeline) during build.

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
* XMX_MEMORY - Max memory, default value 4g
* XMS_MEMORY - Min memory, default value 1g
* MAXPERM_MEMORY - Max prem memory, default value 256m
* PIPELINE_EXECUTOR_MEMORY - Pipeline executor memory, default value 1g
* PARTITION_BYTES - Pipeline bytes, default value 100000000
* SPARK_EXECUTOR_MEMORY - Spark executor memory, default value 8g
* SPARK_MASTER_PORT - Spark master port, default value 7077
* SPARK_MASTER - Spark master, default value sparkmaster.paxatadev.com
* PIPELINE_YARN_NUM_EXECUTORS - Pipeline YARN executors, default value 1
* PIPELINE_YARN_EXECUTOR_CORES - Pipeline YARN CPU cpres, default value 1