#!/usr/bin/env bash

# find . \(\
       # -name '*.sh' \
       # -or -name 'start*' \
       # -or -name 'container-executor.cfg' \
       # -or -name 'paxata-pipeline' \
       # \)\
       # -exec dos2unix {} +

# # Remove old images
# docker rmi -f $(docker images | grep dtr.paxatadev.com | awk '{ print $3 }')

# Build images
docker build -t dtr.paxatadev.com/paxata/paxata-base:8-cdh docker-base
docker build -t docker-kerberos docker-kerberos
docker build -t dtr.paxatadev.com/cloudera/base:5.14.0-kerberos-8-cdh docker-hadoop-base
docker build -t dtr.paxatadev.com/cloudera/namenode:5.14.0-kerberos-8-cdh docker-hadoop-namenode
docker build -t dtr.paxatadev.com/cloudera/datanode-nodemanager:5.14.0-kerberos-8-cdh docker-hadoop-datanode-nodemanager
docker build -t dtr.paxatadev.com/cloudera/resourcemanager:5.14.0-kerberos-8-cdh docker-hadoop-resourcemanager
docker build -t dtr.paxatadev.com/cloudera/spark:5.14.0-spark-2.2.0-kerberos-8-cdh docker-spark
docker build -t dtr.paxatadev.com/cloudera/pipeline:5.14.0-spark-2.2.0-kerberos-8-cdh docker-pipeline
docker build -t dtr.paxatadev.com/cloudera/hive:5.14.0-kerberos-8-cdh docker-hive

# Create network
# docker network create hadoop-network