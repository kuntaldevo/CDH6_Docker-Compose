FROM dtr.paxatadev.com/cloudera/base:5.14.0-kerberos-8-cdh

# Related variables
ARG SPARK_DOWNLOAD_URL=http://archive.cloudera.com/spark2/parcels/2.2/SPARK2-2.2.0.cloudera1-1.cdh5.12.0.p0.142354-el7.parcel
ENV SPARK_HOME=/usr/local/spark
ENV SPARK_CONF_DIR=${SPARK_HOME}/conf
ENV PATH=$PATH:/usr/local/spark/bin:/usr/local/spark/sbin

# Install Spark
RUN SPARK_ARCHIVE_NAME="${SPARK_DOWNLOAD_URL##*/}" && \
    wget ${SPARK_DOWNLOAD_URL} && \
    mkdir ${SPARK_HOME} && \
    tar -C ${SPARK_HOME} --strip-components 3 \
        -xzf ${SPARK_ARCHIVE_NAME} SPARK2*/lib/spark2 && \
    mkdir -p /etc/spark2/conf && \
    mkdir -p /var/run/spark2/work && \
    rm ${SPARK_ARCHIVE_NAME}

# Add configuration files
COPY files/spark-conf ${SPARK_CONF_DIR}
COPY files/start-spark /usr/sbin/

# Change permission
RUN chmod 755 /usr/sbin/start-spark

# Expose ports
# SparkContext web UI on 4040
# Spark master web UI on 8080
# Spark worker web UI on 8081
EXPOSE 4040 8080 8081

# Start bash
CMD ["start-spark"]
