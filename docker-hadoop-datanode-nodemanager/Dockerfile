FROM dtr.paxatadev.com/cloudera/base:5.14.0-kerberos-8-cdh

ENV PIPELINE_CACHE=/usr/local/paxata/pipeline/cache
ENV SPARK_TMP=/usr/local/paxata/spark/tmp

# Install jsvc
RUN yum install -y \
    jsvc \
    yum clean all && \
    rm -Rf /var/cache/yum

# Environment variables
ENV HADOOP_SECURE_DN_USER=root
ENV JSVC_HOME=/usr/bin

# Add configuration files
COPY files/start-hadoop-datanode-nodemanager /usr/sbin/

# Change permission
RUN chmod 755 /usr/sbin/start-hadoop-datanode-nodemanager && \
    mkdir -p ${PIPELINE_CACHE} ${SPARK_TMP} && \
    chown -R paxata:hadoop /usr/local/paxata && \
    chmod 0775 ${PIPELINE_CACHE} && \
    chown spark:hadoop ${SPARK_TMP} && \
    chmod 0777 ${SPARK_TMP}

# Datanode Ports
EXPOSE 50075 50475 50010 8010 50090

# Start hadoop data node and node manager
CMD ["start-hadoop-datanode-nodemanager"]
