FROM dtr.paxatadev.com/cloudera/base:5.14.0-kerberos-8-cdh

# Add configuration files
COPY files/start-hadoop-namenode /usr/sbin/

# Change permission
RUN chmod 755 /usr/sbin/start-hadoop-namenode

# fs.defaultFS
EXPOSE 8020
# dfs.namenode.servicerpc-address
EXPOSE 8022
# dfs.namenode.http-address (HTTP)
EXPOSE 50070
# dfs.namenode.https-address (HTTPS)
EXPOSE 50470

# Start hadoop name node
CMD ["start-hadoop-namenode"]
