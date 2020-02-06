FROM dtr.paxatadev.com/cloudera/spark:5.14.0-spark-2.2.0-kerberos-8-cdh

ENV PIPELINE_HOME=/usr/local/paxata/pipeline

# Need to download the pipeline zip artifact from TC 
COPY files/pipeline ${PIPELINE_HOME}

# Copy scripts
COPY files/bootstrap.sh /root/
COPY files/paxata-pipeline.sh ${PIPELINE_HOME}/
COPY files/init-script/paxata-pipeline /etc/init.d/

# Copy Confd template resource files
COPY files/*.toml /etc/confd/conf.d/

# Copy Confd source templates
COPY files/*.tmpl /etc/confd/templates/

# download and install confd
RUN curl -qL https://github.com/kelseyhightower/confd/releases/download/v0.12.0-alpha3/confd-0.12.0-alpha3-linux-amd64 \
         -o /usr/local/bin/confd && \
    chmod +x /usr/local/bin/confd

RUN chmod 755 /root/bootstrap.sh
RUN chmod 755 /etc/init.d/paxata-pipeline
RUN chmod 755 ${PIPELINE_HOME}/paxata-pipeline.sh

EXPOSE 4040 8090

WORKDIR ${PIPELINE_HOME}

ENTRYPOINT ["/root/bootstrap.sh"]
