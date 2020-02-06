#!/bin/bash

configure_krb_client() {
    wait-for-it.sh $KERBEROS_HOST:88 -t 0
    sed -i 's/KERBEROS_REALM/'"$KERBEROS_REALM"'/g' /etc/krb5.conf
    sed -i 's/KERBEROS_HOST/'"$KERBEROS_HOST"'/g' /etc/krb5.conf
    sed -i 's/DOMAIN_REALM/'"$DOMAIN_REALM"'/g' /etc/krb5.conf
    mkdir -p /var/log/kerberos/
}

create_krb_princ() {
    kadmin -p ${KERBEROS_ADMIN} -w ${KERBEROS_ADMIN_PASSWORD} -q "addprinc -randkey paxata/$(hostname -f)@${KERBEROS_REALM}"
}

create_krb_keytab() {
    kadmin -p ${KERBEROS_ADMIN} -w ${KERBEROS_ADMIN_PASSWORD} -q "xst -k paxata.keytab paxata/$(hostname -f)"
    mv paxata.keytab ${PIPELINE_CONFIG}
    chown paxata:hadoop ${PIPELINE_CONFIG}/paxata.keytab
    chmod 400 ${PIPELINE_CONFIG}/paxata.keytab
}

fix_config() {
    sed -i 's/namenode_hostname/'"$NAMENODE_HOST"'/g' ${HADOOP_CONF_DIR}/core-site.xml
    sed -i 's/namenode_hostname/'"$NAMENODE_HOST"'/g' ${HADOOP_CONF_DIR}/hdfs-site.xml
    sed -i 's/REALM/'"$KERBEROS_REALM"'/g' ${HADOOP_CONF_DIR}/hdfs-site.xml
    sed -i 's/REALM/'"$KERBEROS_REALM"'/g' ${HADOOP_CONF_DIR}/yarn-site.xml
    sed -i 's/REALM/'"$KERBEROS_REALM"'/g' ${HADOOP_CONF_DIR}/mapred-site.xml
    sed -i 's/resourcemanagerhost/'"$RESOURCEMANAGER_HOST"'/g' $HADOOP_CONF_DIR/yarn-site.xml
    sed -i "s/yarn_scheduler_min_alloc_mb/$YARN_SCHEDULER_MIN_ALLOC_MB/g" $HADOOP_CONF_DIR/yarn-site.xml
    sed -i "s/yarn_scheduler_max_alloc_mb/$YARN_SCHEDULER_MAX_ALLOC_MB/g" $HADOOP_CONF_DIR/yarn-site.xml
    sed -i "s/yarn_scheduler_min_alloc_vcores/$YARN_SCHEDULER_MIN_ALLOC_VCORES/g" $HADOOP_CONF_DIR/yarn-site.xml
    sed -i "s/yarn_scheduler_max_alloc_vcores/$YARN_SCHEDULER_MAX_ALLOC_VCORES/g" $HADOOP_CONF_DIR/yarn-site.xml
    sed -i "s/yarn_nm_resource_mem_mb/$YARN_NM_RESOURCE_MEM_MB/g" $HADOOP_CONF_DIR/yarn-site.xml
    sed -i "s/yarn_nm_resource_cpu_vcores/$YARN_NM_RESOURCE_CPU_VCORES/g" $HADOOP_CONF_DIR/yarn-site.xml
    sed -i 's/historyserver_hostname/'"$RESOURCEMANAGER_HOST"'/g' $HADOOP_CONF_DIR/mapred-site.xml
}

set_default_values() {
  if [ "$XMX_MEMORY" = "" ]; then
    XMX_MEMORY=4g
  fi

  if [ "$XMS_MEMORY" = "" ]; then
    XMS_MEMORY=1g
  fi

  if [ "$MAXPERM_MEMORY" = "" ]; then
    MAXPERM_MEMORY=256m
  fi

  if [ "$PIPELINE_EXECUTOR_MEMORY" = "" ]; then
    PIPELINE_EXECUTOR_MEMORY=1g
  fi

  if [ "$PARTITION_BYTES" = "" ]; then
    PARTITION_BYTES=100000000
  fi

  if [ "$SPARK_EXECUTOR_MEMORY" = "" ]; then
    SPARK_EXECUTOR_MEMORY=8g
  fi

  if [ "$SPARK_MASTER_PORT" = "" ]; then
    SPARK_MASTER_PORT=7077
  fi

  if [ "$SPARK_MASTER" = "" ]; then
    SPARK_MASTER=sparkmaster.paxatadev.com
  fi

  if [ "$PIPELINE_YARN_NUM_EXECUTORS" = "" ]; then
    PIPELINE_YARN_NUM_EXECUTORS=1
  fi

  if [ "$PIPELINE_YARN_EXECUTOR_CORES" = "" ]; then
    PIPELINE_YARN_EXECUTOR_CORES=1
  fi
  if [ "$YARN_SCHEDULER_MIN_ALLOC_MB" = "" ]; then
    YARN_SCHEDULER_MIN_ALLOC_MB=1024
  fi
  if [ "$YARN_SCHEDULER_MAX_ALLOC_MB" = "" ]; then
    YARN_SCHEDULER_MAX_ALLOC_MB=8192
  fi
  if [ "$YARN_SCHEDULER_MIN_ALLOC_VCORES" = "" ]; then
    YARN_SCHEDULER_MIN_ALLOC_VCORES=1
  fi
  if [ "$YARN_SCHEDULER_MAX_ALLOC_VCORES" = "" ]; then
    YARN_SCHEDULER_MAX_ALLOC_VCORES=32
  fi
  if [ "$YARN_NM_RESOURCE_MEM_MB" = "" ]; then
    YARN_NM_RESOURCE_MEM_MB=4096
  fi
  if [ "$YARN_NM_RESOURCE_CPU_VCORES" = "" ]; then
    YARN_NM_RESOURCE_CPU_VCORES=8
  fi
}

set_env_variables() {
  SVC_USER=paxata
  SVC_HOST=$(hostname -f)
  SPARK_BIN_HOME=${SPARK_HOME}/bin
  PIPELINE_LIB=/usr/local/paxata/pipeline/lib
  SPARK_YARN_QUEUE=default
  MASTER_URL=yarn
  SPARK_YARN_JARS=${SPARK_HOME}/jars/*.jar
  PIPELINE_CACHE="/usr/local/paxata/pipeline/cache"
  NUM_EXECUTORS=$PIPELINE_YARN_NUM_EXECUTORS
  EXECUTOR_CORES=$PIPELINE_YARN_EXECUTOR_CORES
  EXECUTOR_MEMORY=$PIPELINE_EXECUTOR_MEMORY
  PIPELINE_CONFIG="/usr/local/paxata/pipeline/config"
  PIPELINE_LIB="/usr/local/paxata/pipeline/lib"
  SPARK_LIB_HOME="${SPARK_HOME}/jars"
  CLASSPATH="$PIPELINE_CONFIG:$SPARK_LIB_HOME/*:$PIPELINE_LIB/*:${HADOOP_HOME}/share/hadoop/yarn/*"
}

create_dirs() {
    mkdir -p /usr/local/paxata/pipeline/cache
    chown -R paxata:hadoop /usr/local/paxata
    chmod 0775 /usr/local/paxata/pipeline/cache
    mv /usr/local/paxata/pipeline/lib/pipeline-driver*.jar /usr/local/paxata/pipeline/lib/pipeline.jar
    ln -snf /usr/local/paxata/pipeline/lib/pipeline.jar /usr/local/paxata/pipeline/pipeline.jar
    mv /usr/local/paxata/pipeline/lib/pipeline-rdd*.jar /usr/local/paxata/pipeline/lib/pipeline-rdd.jar
    mkdir -p /usr/local/paxata/spark/tmp
    chown spark:hadoop /usr/local/paxata/spark/tmp
    chmod 0777 /usr/local/paxata/spark/tmp
}

run_pipeline() {
  # Run ConfD to set configuration
  confd -onetime -backend env
  export HADOOP_JAAS_DEBUG=true

  gosu $SVC_USER kinit -kt $PIPELINE_CONFIG/paxata.keytab paxata/$SVC_HOST@$KERBEROS_REALM

  gosu $SVC_USER bash -c "exec $SPARK_BIN_HOME/spark-submit \
                            --jars $PIPELINE_LIB/pipeline-rdd.jar \
                            --driver-memory $XMX_MEMORY \
                            --queue $SPARK_YARN_QUEUE \
                            --deploy-mode client \
                            --master $MASTER_URL \
                            --driver-java-options '-Dspark.yarn.jars=$SPARK_YARN_JARS \
                                                   -Dspark.local.dir=$PIPELINE_CACHE \
                                                   -Dspark.yarn.keytab=${PIPELINE_CONFIG}/paxata.keytab \
                                                   -Dspark.yarn.principal=paxata/$SVC_HOST@$KERBEROS_REALM \
                                                   -Dsun.security.krb5.debug=true \
                                                   -Dsun.security.spnego.debug=true' \
                            --num-executors $NUM_EXECUTORS \
                            --executor-cores=$EXECUTOR_CORES \
                            --executor-memory $EXECUTOR_MEMORY \
                            --driver-class-path $CLASSPATH \
                            --principal "paxata/$SVC_HOST@$KERBEROS_REALM" \
                            --keytab "${PIPELINE_CONFIG}/paxata.keytab" \
                            --class com.paxata.spark.Main $PIPELINE_LIB/pipeline.jar"
}

main() {
    set_default_values
    set_env_variables
    configure_krb_client
    create_krb_princ
    create_krb_keytab
    fix_config
    create_dirs
    run_pipeline
    tail -f /dev/null
}

main "$@"
