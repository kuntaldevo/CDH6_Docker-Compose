FROM dtr.paxatadev.com/cloudera/base:5.14.0-kerberos-8-cdh

# Related variables
ARG HIVE_DOWNLOAD_URL=https://archive.cloudera.com/cdh5/cdh/5/hive-1.1.0-cdh5.14.0.tar.gz

ENV HIVE_HOME=/usr/local/hive
ENV HIVE_CONF_DIR=${HIVE_HOME}/conf
ENV PATH=$PATH:/usr/local/hive/bin:/usr/local/hive/sbin

# Install Hive
RUN HIVE_ARCHIVE_NAME="${HIVE_DOWNLOAD_URL##*/}" && \
    wget ${HIVE_DOWNLOAD_URL} && \
    mkdir ${HIVE_HOME} && \
    tar -xzf ${HIVE_ARCHIVE_NAME} -C ${HIVE_HOME} --strip-components 1 && \
    rm ${HIVE_ARCHIVE_NAME}

# Add configuration files
COPY files/hive-site.xml ${HIVE_CONF_DIR}/
COPY files/start-hive /usr/sbin/

# Add driver jar
COPY files/postgresql-9.4.1212.jre7.jar ${HIVE_HOME}/lib/

# Change permission
RUN chmod 755 /usr/sbin/start-hive

# Expose ports
EXPOSE 9083 10000 10001 10002

# Start bash
CMD ["start-hive"]
