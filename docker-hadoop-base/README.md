## Docker Hadoop Base
This image is based on the docker-base image and contains the CDH 5.12.1 installation. 
This image downloads CDH 5.12.1 tar file (hadoop-2.6.0-cdh5.12.1.tar.gz) during build and put that in /usr/local/hadoop. 
This also sets related environment variables like HADOOP_HOME, HADOOP_CONF_DIR etc.

This also creates following OS users:
* hdfs
* yarn
* mapred
* spark
* hive
* paxata