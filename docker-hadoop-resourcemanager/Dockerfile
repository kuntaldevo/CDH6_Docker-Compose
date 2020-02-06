FROM dtr.paxatadev.com/cloudera/base:5.14.0-kerberos-8-cdh

# Add configuration files
COPY files/start-hadoop-resourcemanager /usr/sbin/

# Change permission
RUN chmod 755 /usr/sbin/start-hadoop-resourcemanager

# yarn.resourcemanager.address
EXPOSE 8032
# yarn.resourcemanager.scheduler.address
EXPOSE 8030
# yarn.resourcemanager.resource-tracker.address
EXPOSE 8031
# yarn.resourcemanager.admin.address
EXPOSE 8033
# yarn.resourcemanager.webapp.address
EXPOSE 8088
# yarn.resourcemanager.webapp.https.address
EXPOSE 8090
# mapreduce.jobhistory.webapp.address
EXPOSE 19888
# mapreduce.jobhistory.webapp.https.address
EXPOSE 19889

# Start resource manager and history server
CMD ["start-hadoop-resourcemanager"]