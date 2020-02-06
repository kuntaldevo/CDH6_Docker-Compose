FROM dtr.paxatadev.com/paxata/paxata-base:8-cdh

# Related variables
ARG HADOOP_DOWNLOAD_URL=https://archive.cloudera.com/cdh5/cdh/5/hadoop-2.6.0-cdh5.14.0.tar.gz

ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_CONF_DIR=/etc/hadoop/conf
ENV PATH=$PATH:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin

# Install Hadoop
RUN HADOOP_ARCHIVE_NAME="${HADOOP_DOWNLOAD_URL##*/}" && \
    wget ${HADOOP_DOWNLOAD_URL} && \
    mkdir -p ${HADOOP_HOME} /etc/hadoop && \
    tar -xzf ${HADOOP_ARCHIVE_NAME} -C ${HADOOP_HOME} --strip-components 1 && \
    rm ${HADOOP_ARCHIVE_NAME} && \
    rm -rf ${HADOOP_HOME}/src && \
    rm -rf ${HADOOP_HOME}/cloudera && \
    chown -R root:root ${HADOOP_HOME}

RUN ln -s ${HADOOP_HOME}/etc/hadoop ${HADOOP_CONF_DIR}

COPY files/hadoop-conf ${HADOOP_CONF_DIR}
COPY files/container-executor ${HADOOP_HOME}/bin/
ADD files/native.tar.gz ${HADOOP_HOME}/lib/

# Create users
RUN groupadd hadoop && \
    useradd -ms /bin/bash -Ng hadoop hdfs && \
    useradd -ms /bin/bash -Ng hadoop yarn && \
    useradd -ms /bin/bash -Ng hadoop mapred && \
    useradd -ms /bin/bash -Ng hadoop spark && \
    useradd -ms /bin/bash -Ng hadoop hive && \
    useradd -ms /bin/bash -Ng hadoop paxata
