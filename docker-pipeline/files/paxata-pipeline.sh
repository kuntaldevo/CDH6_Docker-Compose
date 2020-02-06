#!/bin/bash

NAME=paxata-pipeline

CMDLIST="start stop status restart"
usage="\nUsage is: $CMDLIST\n\tExample: ./$NAME.sh start"

PIPELINE_HOME="$( cd "$(dirname "$0")" ; pwd -P )"
PIPELINE_LOGDIR="$PIPELINE_HOME/logs"
PIPELINE_LIB="$PIPELINE_HOME/lib"
PIPELINE_CONFIG="$PIPELINE_HOME/config"
PIPELINE_LOGFILE="pipeline.log"
PIPELINE_PIDFILE=$PIPELINE_LOGDIR/$NAME.pid

function start() {
  printf "%-50s" "Starting $NAME..."
  ps -ef |grep -v grep |grep D$NAME > /dev/null 2>&1
  if [ $? == 0 ]
  then
      echo -e "[\e[0;31m FAILED \e[0m]\n\t$NAME appears to already be running, do you have a zombie process?"
      return 1
  fi
  PIPELINE_PORT=`cat $PIPELINE_CONFIG/http.properties | grep -v '#' | grep "port=" | cut -d = -f 2 -`
  RETRY=1

  SPARK_HOME=`cat $PIPELINE_CONFIG/spark.properties | grep -v '#' | grep "spark.home=" | cut -d = -f 2 -`
  SPARK_CONF_HOME=$SPARK_HOME/conf
  SPARK_BIN_HOME=$SPARK_HOME/bin
  SPARK_LIB_HOME=$SPARK_HOME/lib

  LOG4J_CONFIG="$PIPELINE_CONFIG/log4j.properties"

  # Make sure the log directory exists
  mkdir -p $PIPELINE_LOGDIR

  netstat -lnt |grep ":$PIPELINE_PORT "  &>/dev/null 2>&1
  STATE=$?
  if [ $STATE == 1 ]
  then
      MASTER_URL=`cat $PIPELINE_CONFIG/spark.properties | grep -v '#' | grep "master.url=" | cut -d = -f 2 -`
      if [[ $MASTER_URL != "spark://"* ]] && [[ $MASTER_URL != "yarn-client" ]]
      then
         echo -e "[\e[0;31m FAILED \e[0m]\n\t$MASTER_URL is not currently a supported configuration. Please contact support with questions"
         exit 1
      elif [ $MASTER_URL != "yarn-client" ]
      then
        MASTER_HOSTPORT=`echo $MASTER_URL | tr -s '/' | cut -d / -f 2 -`
        MASTER_HOST=`echo $MASTER_HOSTPORT | cut -d : -f 1 -`
        MASTER_PORT=`echo $MASTER_HOSTPORT | cut -d : -f 2 -`

        ADDRS=$(dig +short $MASTER_HOST); if [ -z "$ADDRS" ]; then ADDRS_STATE=FAILURE; else ADDRS_STATE=SUCCESS; fi
        ADDRS2=$(cat /etc/hosts |grep -q $MASTER_HOST); if [ $? = 0 ]; then ADDRS_ALT_STATE=SUCCESS; else ADDRS_ALT_STATE=FAILURE; fi
        if [[ "$ADDRS_STATE" == "SUCCESS" ]] || [[ "$ADDRS_ALT_STATE" == "SUCCESS" ]]
        then
           timeout 1 bash -c "cat < /dev/null > /dev/tcp/$MASTER_HOST/$MASTER_PORT" >/dev/null 2>&1
           STATE=$?
           while [[ ($STATE -eq 1) && ($RETRY -le 5) ]]
           do
             echo -e "\n\tMaster isn't responding on hostname $MASTER_HOST with port $MASTER_PORT, waiting and retrying"
             sleep 5
             (( RETRY++ ))
             timeout 1 bash -c "cat < /dev/null > /dev/tcp/$MASTER_HOST/$MASTER_PORT" >/dev/null 2>&1
             STATE=$?
           done

           if [ $STATE -eq 124 ]
           then
              echo -e "[\e[0;31m FAILED \e[0m]\n\tYou may have a firewall blocking your access to the Spark Master: $MASTER_HOST with port $MASTER_PORT"
              return 1
           fi

          if [ $RETRY -gt "5" ]
          then
            echo -e "[\e[0;31m FAILED \e[0m]\n\tUnable to reach spark master at $MASTER_HOST with port $MASTER_PORT, exiting"
            return 1
          fi
        else
          echo -e "[\e[0;31m FAILED \e[0m]\n\tThe Spark Master: $MASTER_HOST could not be resolved by DNS nor in /etc/hosts"
          return 1
        fi
      fi

      CLASSPATH=$PIPELINE_CONFIG:$SPARK_LIB_HOME/*:$PIPELINE_LIB/*

      XMX=`cat $PIPELINE_CONFIG/paxata.properties | grep -v '#' | grep "px.xmx=" | cut -d = -f 2 -`
      XMS=`cat $PIPELINE_CONFIG/paxata.properties | grep -v '#' | grep "px.xms=" | cut -d = -f 2 -`
      XX=`cat $PIPELINE_CONFIG/paxata.properties | grep -v '#' | grep "px.xx" |awk -F 'px.xx.' '{print "-XX:"$2}' |tr '\n' ' '`
      EXECUTOR_MEMORY=`cat $PIPELINE_CONFIG/paxata.properties | grep -v '#' | grep "px.executor.memory=" | cut -d = -f 2 -`
      PIPELINE_CACHE=`cat $PIPELINE_CONFIG/paxata.properties | grep -v '#' | grep "px.rootdir" | cut -d = -f 2 -`

      cd $PIPELINE_HOME
      if [ $MASTER_URL != "yarn-client" ]
      then
        exec java -Xmx$XMX -Xms$XMS $XX -D$NAME -Dlog4j.configuration=$LOG4J_CONFIG -Dspark.executor.memory=$EXECUTOR_MEMORY -Dspark.local.dir=$PIPELINE_CACHE -classpath $CLASSPATH com.paxata.spark.Main >> $PIPELINE_LOGDIR/$PIPELINE_LOGFILE 2>&1 &
      else
         NUM_EXECUTORS=`cat $PIPELINE_CONFIG/spark.properties | grep -v '#' | grep "yarn.num.executors=" | cut -d = -f 2 -`
         EXECUTOR_CORES=`cat $PIPELINE_CONFIG/spark.properties | grep -v '#' | grep "yarn.executor.cores=" | cut -d = -f 2 -`
         export HADOOP_CONF_DIR=`cat $PIPELINE_CONFIG/spark.properties | grep -v '#' | grep "hadoop.conf=" | cut -d = -f 2 -`
         SPARK_YARN_JAR=`cat $PIPELINE_CONFIG/spark.properties | grep -v '#' | grep "spark.yarn.jar=" | cut -d = -f 2 -`
         SPARK_YARN_QUEUE=`cat $PIPELINE_CONFIG/spark.properties | grep -v '#' | grep "spark.yarn.queue=" | cut -d = -f 2 -`
         exec $SPARK_BIN_HOME/spark-submit --jars "$PIPELINE_LIB/pipeline-rdd.jar" --driver-memory "$XMX" --queue "$SPARK_YARN_QUEUE" --deploy-mode "client" --master "$MASTER_URL" --driver-java-options "-Dspark.yarn.jar=$SPARK_YARN_JAR -Dspark.local.dir=$PIPELINE_CACHE $XX" --num-executors "$NUM_EXECUTORS" --executor-cores="$EXECUTOR_CORES" --executor-memory "$EXECUTOR_MEMORY" --driver-class-path "$CLASSPATH" --class com.paxata.spark.Main $PIPELINE_LIB/pipeline.jar >> $PIPELINE_LOGDIR/$PIPELINE_LOGFILE 2>&1 &
      fi

      PIPELINE_PID=$!
      sleep 1
      if [ -z "`ps axf | grep ${PIPELINE_PID} | grep -v grep`" ]; then
        echo -e "[\e[0;31m FAILED \e[0m]\n\tUnable to start $NAME"
        tail -n 5 $PIPELINE_LOGDIR/$PIPELINE_LOGFILE
      else
        echo -e "[\e[0;32m OK \e[0m]"
        echo $PIPELINE_PID >$PIPELINE_PIDFILE
        echo -e "\nProcess is running in the background as PID: $PIPELINE_PID"
        echo "Output file is: $PIPELINE_LOGDIR/$PIPELINE_LOGFILE"
      fi
  else
      echo -e "[\e[0;31m FAILED \e[0m]\n\tPort $PIPELINE_PORT is already listening, do you have a zombie process?"
      return 1
  fi
}

function stop(){
    printf "%-50s" "Stopping $NAME"
  if [ -f $PIPELINE_PIDFILE ]
  then
      PID=`cat $PIPELINE_PIDFILE`
      echo
      (hash jstack 2>/dev/null || {
        echo >&3 "Not taking jstack of existing process. Please set up jstack to gain this functionality";
        false;
        }) && {
        filename=$PIPELINE_LOGDIR/$NAME-`date '+%Y-%m-%d-%H-%M-%S'`-jstack.txt
        echo "Dumping jstack of existing process to" $filename
        jstack -l $PID > $filename
        }
        sleep 3
        kill -HUP $PID
        echo "Waiting for process to terminate..."
        sleep 1
        while ps -p $PID > /dev/null; do echo -n "."; sleep 1; done
        echo -e "[\e[0;32m OK \e[0m]"
        rm -f $PIPELINE_PIDFILE
    else
        echo -e "[\e[0;31m FAILED \e[0m]\n\tPidfile not found"
    fi
}

function status(){
  if [ -f $PIPELINE_PIDFILE ]; then
      PID=`cat $PIPELINE_PIDFILE`
      if [ -z "`ps axf | grep ${PID} | grep -v grep`" ]; then
        echo -e "[\e[0;31m FAILED \e[0m]\n\tProcess dead but pidfile exists"
      else
        echo -e "$NAME (pid  $PID) is running..."
      fi
    else
      echo -e "\n$NAME is stopped"
    fi
}

function restart(){
  stop
  start
}

for i in $CMDLIST
do
  if [ "$1" == "$i" ]
  then
      VALIDCOMMAND="true"
  fi
done

if [ "$VALIDCOMMAND" == "true" ]
then
  $1
else
  echo -e "$usage"
  exit
fi
