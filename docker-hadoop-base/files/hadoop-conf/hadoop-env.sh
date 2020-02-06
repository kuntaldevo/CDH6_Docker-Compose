# The java implementation to use.                                               
if [ "$JAVA_HOME" != "" ]; then
    export JAVA_HOME=${JAVA_HOME}
fi

if [ "$JAVA_HOME" = "" ]; then
  echo "Error: JAVA_HOME is not set."
  exit 1
fi

JAVA=$JAVA_HOME/bin/java

# Where log files are stored.  $HADOOP_HOME/logs by default.
export HADOOP_LOG_DIR="/var/log/hdfs"

#export HADOOP_PID_DIR="/var/run/hadoop"

# Path to jsvc required by secure datanode
# Centos
#export JSVC_HOME=/usr/lib/bigtop-utils

#Secure Data nodes
#export HADOOP_SECURE_DN_USER=hdfs
export HADOOP_SECURE_DN_PID_DIR="/var/run/hdfs"
export HADOOP_SECURE_DN_LOG_DIR=/var/log/hdfs
#export JSVC_HOME=/usr/lib/bigtop-utils

#export HADOOP_DATANODE_OPTS='-Xmx8192m'
#export HADOOP_NAMENODE_OPTS='-Xmx8192m'
#export HADOOP_JOB_HISTORYSERVER_OPTS='-Xmx2048m'

# The following applies to multiple commands (fs, dfs, fsck, distcp etc)
export HADOOP_CLIENT_OPTS="-Xmx128m $HADOOP_CLIENT_OPTS"

# The maximum amount of heap to use, in MB. Default is 1000.
export HADOOP_HEAPSIZE=1024

export HADOOP_NAMENODE_OPTS="-Xmx1024m -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=70 -XX:+CMSParallelRemarkEnabled -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=3330 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"

export HADOOP_DATANODE_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=3331 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"

export HADOOP_JOB_HISTORYSERVER_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=3334 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false "

#sudo ulimit -n  1000000

